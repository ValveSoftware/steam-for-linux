Steam for Linux Client
======================

This is the README for the Steam for Linux client.

Hardware and Software Requirements
----------------------------------
Steam for Linux requires the following:

- OS: Latest Ubuntu or Ubuntu LTS with a 64-bit (`x86_64`, `AMD64`) Linux kernel
- Processor: 1GHz Pentium 4 or AMD Opteron equivalent or better
    - Any `x86_64` / `AMD64` CPU with support for the `CMPXCHG16B` and `SSE3` instruction sets
- Memory: 512 MB RAM
- Graphics: Any NVIDIA / AMD / Intel
    - Requires latest 64-bit (`x86_64`, `AMD64`) *and* 32-bit (`i386`, `IA32`) graphics drivers. Install them using `sudo ubuntu-drivers autoinstall`.
- Storage: 5 GB available space
- Additional Notes:
    - Requires internet connection for initial installation
    - Requires 64-bit (`x86_64`, `AMD64`) *and* 32-bit (`i386`, `IA32`) glibc

Getting Started
---------------
Install Steam for Linux client:

1. Download the `steam_latest.deb` package from this [location](https://media.steampowered.com/client/installer/steam.deb).
2. Navigate to the directory containing `steam_latest.deb` and double-click it. This launches Ubuntu Software Center and installs the package.
3. If you prefer to install from the command-line, use gdebi. Install the `gdebi-core` package (`apt install gdebi-core`) and then install the Steam for Linux package (`gdebi steam_latest.deb`).

For a list of games supported by Steam for Linux either visit this [page](https://support.steampowered.com/kb_article.php?ref=8495-OKZC-0159) or click Store (from the client) and then the Linux tab on the far right. We recommend that you join the Steam for Linux official game group, located [here](https://steamcommunity.com/app/221410). You will find future beta announcements and other information posted here as well as an active discussion forum.

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
