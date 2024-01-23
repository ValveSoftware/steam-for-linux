Steam for Linux Client
======================

This is the README for the Steam for Linux client.

Hardware and Software Requirements
----------------------------------
Steam for Linux requires the following:

- 1 GHz Pentium 4 or AMD Opteron with:
    - x86-64 (AMD64) instruction set
    - CMPXCHG16B instruction support (`cx16` in `/proc/cpuinfo` flags)
    - SSE3 instruction support (`pni` in `/proc/cpuinfo` flags)
- 512 megabytes of RAM and 5 gigabytes of hard drive space, or better
- Internet connection (Cable/DSL speeds recommended)
- Latest Ubuntu LTS, fully updated
- 64-bit (x86-64, AMD64) Linux kernel
- 64-bit (x86-64, AMD64) *and* 32-bit (i386, IA32) graphics drivers and glibc
- Latest graphics driver
- NVidia driver support - For recent cards (e.g. series 8), you will need to install 310.x. For older cards, driver 304.x supports the NVidia 6 and 7 GPU series. To access these drivers, first update your cache and then install the specific [driver](https://support.steampowered.com/kb_article.php?ref=8509-RFXM-1964) you need from the list in Additional Drivers.
- AMD and Intel driver support - you will need to use the latest Mesa drivers, Mesa 9 or later. These should be preinstalled on your Distro

Getting Started
---------------

1. Add the official apt repsository and signing key:

```bash
sudo curl -o /usr/share/keyrings/steam.gpg https://repo.steampowered.com/steam/archive/stable/steam.gpg
sudo tee /etc/apt/sources.list.d/steam-stable.list <<'EOF'
deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
deb-src [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
EOF
```
2. Add 32-bit support (if on amd64)
```
sudo dpkg --add-architecture i386
```
3. Update the package cache, and install steam and its dependencies
```sudo
sudo apt-get update
sudo apt-get install \
  libgl1-mesa-dri:amd64 \
  libgl1-mesa-dri:i386 \
  libgl1-mesa-glx:amd64 \
  libgl1-mesa-glx:i386 \
  steam-launcher
```

Reporting Issues
----------------

If you encounter an issue with Steam for Linux, first search the [issue list](https://github.com/ValveSoftware/steam-for-linux/issues) to see if it has already been reported. Include closed issues in your search.

For issues with:

* Source-based games (HL2:DM, HL2, HL2:EP1, HL2:EP2, TF2, DoD:S, CS:S), visit our [Source Issue List](https://github.com/ValveSoftware/Source-1-Games/issues)
* GoldSrc-based games (HL, HL:BS, HL:OF, TFC, DoD, DMC, CS, CS:CZ or Ricochet), visit our [Half-Life Issue List](https://github.com/ValveSoftware/halflife/issues)
* Portal 2, visit our [Portal 2 Issue List](https://github.com/ValveSoftware/portal2/issues)
* CS:GO, visit our [CS:GO Issue List](https://github.com/ValveSoftware/csgo-osx-linux/issues)
* Games using Proton, visit our [Proton Issue List](https://github.com/ValveSoftware/Proton/issues)

If it has not been reported, create a new issue with the following information:

- a short, descriptive title;
- a detailed description of the issue, including any output from the command line;
- steps for reproducing the issue; and
- your [system information](#system-information).

Please place logs either in a code block ([go here](https://guides.github.com/features/mastering-markdown/) for a GFM cheat sheet) or a [gist](https://gist.github.com).

When possible, please include a differential between a working configuration and the reported issue.

If a crash is involved, please include any CrashIDs or minidumps related to the issue in an archive. Archives can be drag and dropped into the text box of github.

For tracking purposes, there should be one issue per issue report.

### System Information

System information can be gathered from within steam (`Help -> System Information`).

Once your information appears: right-click within the dialog, choose `Select All`, right-click again, and then choose `Copy`.
Paste this information into a [gist](https://gist.github.com/) and include a link to it from your bug report.


Conduct
-------


There are basic rules of conduct that should be followed at all times by everyone participating in the discussions.  While this is generally a relaxed environment, please remember the following:

- Do not insult, harass, or demean anyone.
- Do not intentionally multi-post an issue.
- Do not use ALL CAPS when creating an issue report.
- Do not repeatedly update an open issue remarking that the issue persists.

Remember: Just because the issue you reported was reported here does not mean that it is an issue with Steam. Also, should your issue not be resolved immediately, it does not mean that a resolution is not being researched or tested. Patience is always appreciated.
