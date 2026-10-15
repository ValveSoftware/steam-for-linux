#!/usr/bin/env bash
#
# bin_steam.sh - launcher script for Steam on Linux
# Copyright Valve Corporation. All rights reserved
#
# This is the Steam script that typically resides in /usr/bin
# It will create the Steam bootstrap if necessary and then launch steam.

# verbose
#set -x

set -e

# Get the full name of this script
STEAMSCRIPT="$(cd "${0%/*}" && echo "$PWD")/${0##*/}"
export STEAMSCRIPT
bootstrapscript="$(readlink -f "$STEAMSCRIPT")"
bootstrapdir="$(dirname "$bootstrapscript")"
log_opened=

log () {
    echo "bin_steam.sh[$$]: $*" >&2 || :
}

export STEAMSCRIPT_VERSION=1.0.0.85

# Set up domain for script localization
export TEXTDOMAIN=steam

function show_message()
{
	style=$1
	shift

	case "$style" in
	--error)
		title=$"Error"
		;;
	--warning)
		title=$"Warning"
		;;
	*)
		title=$"Note"
		;;
	esac

	log "$title: $*"

	if [ "${XDG_CURRENT_DESKTOP}" == "gamescope" ]; then
		return
	fi

	if ! zenity "$style" --text="$*" 2>/dev/null; then
		# Save the prompt in a temporary file because it can have newlines in it
		tmpfile="$(mktemp || echo "/tmp/steam_message.txt")"
		echo -e "$*" >"$tmpfile"
		xterm -T "$title" -e "cat $tmpfile; echo -n 'Press enter to continue: '; read input"
		rm -f "$tmpfile"
	fi
}

# Function to show progress bar during update
function show_update_progress()
{
    local steam_cmd="$1"
    shift
    
    # Create a temporary file to track progress
    local progress_file=$(mktemp)
    
    # Start Zenity progress bar
    (
        echo "0"
        echo "# Starting Steam update..."
        
        # Monitor progress file for updates
        local last_percent=0
        while [ ! -f "$progress_file.done" ]; do
            if [ -f "$progress_file" ]; then
                local current_percent=$(cat "$progress_file" 2>/dev/null | head -1)
                if [[ "$current_percent" =~ ^[0-9]+$ ]] && [ "$current_percent" -ne "$last_percent" ]; then
                    echo "$current_percent"
                    local status_text=$(cat "$progress_file" 2>/dev/null | sed -n '2p')
                    if [ -n "$status_text" ]; then
                        echo "# $status_text"
                    else
                        echo "# Progress: $current_percent%"
                    fi
                    last_percent=$current_percent
                fi
            fi
            sleep 1
        done
        
        echo "100"
        echo "# Update complete!"
    ) | zenity --progress \
        --title="Steam Update" \
        --text="Starting Steam update..." \
        --percentage=0 \
        --auto-close \
        --width=400 \
        --no-cancel 2>/dev/null &
    
    local zenity_pid=$!
    
    # Execute Steam and monitor its output
    {
        # Track if this is the first run
        local first_run_marker="$LAUNCHSTEAMDIR/.first_run_done"
        
        "$steam_cmd" "$@" 2>&1 | while IFS= read -r line; do
            log "Steam output: $line"
            
            # Extract progress percentage
            local percent=$(echo "$line" | grep -o '\[[[:space:]]*[0-9]\+%\]' | sed 's/\[[[:space:]]*\([0-9]\+\)%\]/\1/' | head -1)
            
            if [ -n "$percent" ]; then
                echo "$percent" > "$progress_file"
                echo "Downloading update... ($percent%)" >> "$progress_file"
            elif echo "$line" | grep -q "Verifying installation"; then
                echo "25" > "$progress_file"
                echo "Verifying installation..." >> "$progress_file"
            elif echo "$line" | grep -q "Downloading Update"; then
                echo "10" > "$progress_file"
                echo "Checking for updates..." >> "$progress_file"
            elif echo "$line" | grep -q "Update complete"; then
                echo "100" > "$progress_file"
                echo "Update complete!" >> "$progress_file"
                touch "$progress_file.done"
            elif echo "$line" | grep -q "Cleaning up"; then
                echo "90" > "$progress_file"
                echo "Cleaning up..." >> "$progress_file"
            elif echo "$line" | grep -q "Extracting"; then
                echo "50" > "$progress_file"
                echo "Extracting files..." >> "$progress_file"
            elif echo "$line" | grep -q "Installing update"; then
                echo "75" > "$progress_file"
                echo "Installing update..." >> "$progress_file"
            fi
        done
        
        # Mark first run as done after successful update
        if [ ! -f "$first_run_marker" ]; then
            touch "$first_run_marker"
        fi
        
        # Ensure completion
        echo "100" > "$progress_file"
        echo "Steam is ready!" >> "$progress_file"
        touch "$progress_file.done"
        
        # Wait for Zenity to close
        sleep 2
        kill $zenity_pid 2>/dev/null || true
        
        # Clean up
        rm -f "$progress_file" "$progress_file.done"
    } &
    
    local steam_pid=$!
    
    # Wait for Steam process to complete
    wait $steam_pid 2>/dev/null || true
    
    # Final cleanup
    kill $zenity_pid 2>/dev/null || true
    rm -f "$progress_file" "$progress_file.done"
}

# Keep in sync with the function of the same name in steam.sh
# Usage: maybe_open_log $STEAM_RUNTIME_SCOUT ~/.steam/steam "$*"
# Uses globals: log_opened + environment variables set by srt-logger
function maybe_open_log()
{
	local srt="$1"
	local data="$2"
	local argv="$3"

	case " $argv " in
		(*\ -srt-logger-opened\ *)
			log "Log already open"
			return 0
			;;
	esac

	if [ -n "$log_opened" ]; then
		return 0
	fi

	if [ "${STEAM_RUNTIME_LOGGER-}" = "0" ]; then
		# Interferes with vscode's gdb wrapping for instance
		log "Logging to console-linux.txt disabled via STEAM_RUNTIME_LOGGER"
		return 0
	fi

	if [ "x${DEBUGGER-}" != "x" ]; then
		# Interferes with ncurses (cgdb etc.)
		log "Setting up for debugging, not logging to console-linux.txt"
		return 0
	fi

	local log_folder="${STEAM_CLIENT_LOG_FOLDER:-logs}"

	# Avoid using mkdir -p here: if ~/.steam/steam is somehow missing,
	# we don't want to create it as a real directory
	if [ -d "$data/$log_folder" ] || mkdir "$data/$log_folder"; then
		log_dir="$data/$log_folder"
	else
		log "Couldn't create $data/$log_folder, not logging to console-linux.txt"
		return 0
	fi

	if source "${srt}/usr/libexec/steam-runtime-tools-0/logger-0.bash" \
		--log-directory="$log_dir" \
		--filename=console-linux.txt \
		--parse-level-prefix \
		-t steam \
	; then
		log_opened=1
	else
		log "Couldn't set up srt-logger, not logging to console-linux.txt"
	fi
}

function detect_platform()
{
	# Maybe be smarter someday
	# Right now this is the only platform we have a bootstrap for, so hard-code it.
	echo ubuntu12_32
}

function setup_variables()
{
	# 'steam' or sometimes 'steambeta'
	STEAMPACKAGE="${0##*/}"

	if [ "$STEAMPACKAGE" = bin_steam.sh ]; then
		STEAMPACKAGE=steam
	fi

	STEAMCONFIG=~/.steam
	# ~/.steam/steam or ~/.steam/steambeta
	STEAMDATALINK="$STEAMCONFIG/$STEAMPACKAGE"
	STEAMBOOTSTRAP=steam.sh
	# User-controlled, often ~/.local/share/Steam or ~/Steam
	LAUNCHSTEAMDIR="$(readlink -e -q "$STEAMDATALINK" || true)"
	# Normally 'ubuntu12_32'
	LAUNCHSTEAMPLATFORM="$(detect_platform)"
	# Often in /usr/lib/steam
	LAUNCHSTEAMBOOTSTRAPFILE="$bootstrapdir/bootstraplinux_$LAUNCHSTEAMPLATFORM.tar.xz"
	if [ ! -f "$LAUNCHSTEAMBOOTSTRAPFILE" ]; then
		LAUNCHSTEAMBOOTSTRAPFILE="/usr/lib/$STEAMPACKAGE/bootstraplinux_$LAUNCHSTEAMPLATFORM.tar.xz"
	fi

	# Get the default data path
	STEAM_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
	case "$STEAMPACKAGE" in
		steam)
			CLASSICSTEAMDIR="$HOME/Steam"
			DEFAULTSTEAMDIR="$STEAM_DATA_HOME/Steam"
			;;
		steambeta)
			CLASSICSTEAMDIR="$HOME/SteamBeta"
			DEFAULTSTEAMDIR="$STEAM_DATA_HOME/SteamBeta"
			;;
		*)
			log $"Unknown Steam package '$STEAMPACKAGE'"
			exit 1
			;;
	esac

	# Create the config directory if needed
	if [[ ! -d "$STEAMCONFIG" ]]; then
		mkdir "$STEAMCONFIG"
	fi
}

function install_bootstrap()
{
	STEAMDIR="$1"

	# Save the umask and set strong permissions
	omask="$(umask)"
	umask 0077

	log $"Setting up Steam content in $STEAMDIR"
	mkdir -p "$STEAMDIR"
	cd "$STEAMDIR"
	
	# Show progress during extraction for first installation
	if [ ! -f "$STEAMDIR/.first_run_done" ]; then
		(
			echo "0"
			echo "# Preparing Steam installation..."
			echo "50"
			echo "# Extracting Steam files..."
			if ! tar xJf "$LAUNCHSTEAMBOOTSTRAPFILE" ; then
				echo "100"
				echo "# Installation failed!"
				exit 1
			fi
			echo "100"
			echo "# Extraction complete!"
		) | zenity --progress \
			--title="Installing Steam" \
			--text="Starting installation..." \
			--percentage=0 \
			--auto-close \
			--width=350 2>/dev/null || true
	else
		if ! tar xJf "$LAUNCHSTEAMBOOTSTRAPFILE" ; then
			log $"Failed to extract $LAUNCHSTEAMBOOTSTRAPFILE, aborting installation."
			exit 1
		fi
	fi
	
	ln -fns "$STEAMDIR" "$STEAMDATALINK"
	setup_variables

	# put the Steam icon on the user's desktop
	# try to read ~/.config/user-dirs.dirs to get the current desktop configuration
	# http://www.freedesktop.org/wiki/Software/xdg-user-dirs
	# shellcheck source=/dev/null
	test -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" && source "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
	DESKTOP_DIR="${XDG_DESKTOP_DIR:-$HOME/Desktop}"

	if [ -d "$DESKTOP_DIR" ] && [ "$bootstrapdir" = "/usr/lib/$STEAMPACKAGE" ]; then
		# There might be a symlink in place already, in such case we do nothing
		if [ ! -L "$DESKTOP_DIR/$STEAMPACKAGE.desktop" ]; then
			cp "$bootstrapdir/$STEAMPACKAGE.desktop" "$DESKTOP_DIR"
			# Older .desktop implementations used the execute bits as
			# a marker for a .desktop being safe to treat as a shortcut
			chmod a+x "$DESKTOP_DIR/$STEAMPACKAGE.desktop"
			if command -v gio >/dev/null; then
				# Making it executable is not enough in recent
				# (Ubuntu 20.04) versions of
				# https://gitlab.gnome.org/World/ShellExtensions/desktop-icons
				gio set --type=string "$DESKTOP_DIR/$STEAMPACKAGE.desktop" metadata::trusted true || :
				# Generate an inotify event so the desktop
				# implementation reloads it
				touch "$DESKTOP_DIR/$STEAMPACKAGE.desktop"
			fi
		fi
	fi

	# Restore the umask
	umask "$omask"
}

function repair_bootstrap()
{
	ln -fns "$1" "$STEAMDATALINK"
	setup_variables
}

function check_bootstrap()
{
	local data="$1"
	# Normally we would look for ubuntu12_32/steam-runtime in
	# ~/.steam/root rather than ~/.steam/steam if different, but in
	# this script we assume that ~/.steam/steam and ~/.steam/root
	# are the same: they only differ in developer use-cases which
	# also bypass this script
	local srt="${STEAM_RUNTIME_SCOUT:-"$data/ubuntu12_32/steam-runtime"}"
	local argv="$2"

	if [[ -n "$data" && -x "$data/$STEAMBOOTSTRAP" ]]; then
		# Looks good...
		maybe_open_log "$srt" "$data" "$argv"
		return 0
	else
		return 1
	fi
}

function forward_command_line()
{
	if ! [ -p "$STEAMCONFIG/steam.pipe" ]; then
		return 1
	fi

	local runtime="$STEAMCONFIG/root/ubuntu12_32/steam-runtime"
	local remote="$runtime/amd64/usr/bin/steam-runtime-steam-remote"

	if [ -x "$remote" ] && "$remote" "$@" 2>/dev/null; then
		return 0
	else
		return 1
	fi
}

# Don't allow running as root
if [ "$(id -u)" == "0" ]; then
	show_message --error $"Cannot run as root user"
	exit 1
fi

# Look for the Steam data files
setup_variables

# If Steam is already running, try to forward the command-line to it.
# If successful, there's nothing more to do.
if forward_command_line "$@"; then
	exit 0
fi

if ! check_bootstrap "$LAUNCHSTEAMDIR" "$*"; then
	# See if we just need to recreate the data link
	if check_bootstrap "$DEFAULTSTEAMDIR" "$*"; then
		# Usually ~/.steam/steam -> ~/.local/share/Steam
		log $"Repairing installation, linking $STEAMDATALINK to $DEFAULTSTEAMDIR"
		repair_bootstrap "$DEFAULTSTEAMDIR"
	elif check_bootstrap "$CLASSICSTEAMDIR" "$*"; then
		# Legacy: ~/.steam/steam -> ~/Steam
		log $"Repairing installation, linking $STEAMDATALINK to $CLASSICSTEAMDIR"
		repair_bootstrap "$CLASSICSTEAMDIR"
	fi
fi

if [[ ! -L "$STEAMDATALINK" ]] || ( ! check_bootstrap "$LAUNCHSTEAMDIR" "$*" ); then
	install_bootstrap "$DEFAULTSTEAMDIR"
fi

if ! check_bootstrap "$LAUNCHSTEAMDIR" "$*"; then
	show_message --error $"Couldn't set up Steam data - please contact technical support"
	exit 1
fi

# Leave a copy of the bootstrap tarball in ~/.steam so that Steam can
# re-bootstrap itself if required
if ! cmp -s "$LAUNCHSTEAMBOOTSTRAPFILE" "$LAUNCHSTEAMDIR/bootstrap.tar.xz"; then
    cp "$LAUNCHSTEAMBOOTSTRAPFILE" "$LAUNCHSTEAMDIR/bootstrap.tar.xz"
fi

STEAMDEPS="${STEAMSCRIPT%/*}/steamdeps"
if [ -x "$STEAMDEPS" ]; then
	if ! "$STEAMDEPS"; then
		log "Unable to install Steam dependencies by running $STEAMDEPS, trying to continue anyway..."
	fi
fi

# go to the install directory and run the client
cd "$LAUNCHSTEAMDIR"

# Show progress bar during first installation
if [ ! -f "$LAUNCHSTEAMDIR/.first_run_done" ]; then
    show_update_progress "$LAUNCHSTEAMDIR/$STEAMBOOTSTRAP" ${log_opened+-srt-logger-opened} "$@"
else
    # Normal execution without progress bar
    exec "$LAUNCHSTEAMDIR/$STEAMBOOTSTRAP" ${log_opened+-srt-logger-opened} "$@"
fi
