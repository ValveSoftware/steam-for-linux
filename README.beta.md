SteamRT3c Steam Client for Linux
================================

This is the README for the steamrt3c beta client.

Steam is primarily designed to run on typical desktop Linux operating systems
such as the Arch, Debian and Fedora OS families,
targeting common desktop environments like KDE Plasma and GNOME.

It can often be run in other environments,
but the more closely the operating system and desktop environment follow
typical conventions,
the more likely it is that Steam will work as expected.

Operating System Requirements
-----------------------------

The following are **required** to run the Steam client:
* libc: glibc 2.31 or newer
* Kernel: Linux kernel 5.6 or newer
* Ability to create new user and mount namespaces without special privileges
    - `/proc/sys/user/max_user_namespaces` sufficiently high (default value recommended)
    - `/proc/sys/user/max_mnt_namespaces` sufficiently high (default value recommended)
    - `/proc/sys/kernel/unprivileged_userns_clone` set to 1, if it exists
    - if using AppArmor, either Steam runs under an AppArmor profile that allows `userns,`, or `/proc/sys/kernel/apparmor_restrict_unprivileged_unconfined` set to 0
* D-Bus session bus
* X11 server, either Xwayland or an X11 session
* Either pipewire-pulse or PulseAudio
    - JACK is **not supported**
    - ALSA dmix is **not supported**
* OpenGL drivers
* Vulkan drivers
* Architectures:
    - `x86_64` systems must support multilib and have both 32-bit (`x86`, `i386`, `lib32`) and 64-bit (`x86_64`, `amd64`) versions of required libraries and graphics drivers installed
    - 64-bit-only `x86_64` systems are **not supported**
    - 32-bit-only `x86` systems are **not supported**

The following features are **recommended** to run the Steam client:
* xdg-desktop-portal: allows the client to open native file chooser dialogs
* udisks2: automatic library discovery on external drive hotplug
* `systemd --user` (`pam_systemd.so`): control groups and resource management for game processes
* Hardware-accelerated video encoding/decoding drivers: for streaming and game recording
    * Recommended codecs: x264, x265
    * Supported APIs: VA-API, NVENC, CUDA
    * Both 32-bit and 64-bit drivers recommended

The following features are **recommended** when running the Steam client as an OS shell (e.g. SteamOS Game Mode):
* pipewire and pipewire-pulse: audio device configuration
* NetworkManager: WiFi connection management
* udisks2: formatting disks and removable media

The Steam Runtime provides a compatibility layer for running Steam on
multiple Linux distributions.
Its documentation includes some
[technical details about distribution assumptions][distro assumptions]
which might be useful to distribution vendors.

[distro assumptions]: https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md

Hardware Requirements
---------------------

* CPU Features: `x86_64` / `AMD64` CPU with support for:
    - `CMPXCHG16B`
    - `SSE3`
* Vulkan compatible graphics card
