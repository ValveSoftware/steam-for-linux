Steam for Linux Client
======================

This is the README for the Steam for Linux beta client.

Hardware and Software Requirements
----------------------------------
Steam for Linux requires the following:

- 1 GHz Pentium 4 or AMD Opteron with 512 megabytes of RAM and 5 gigabytes of hard drive space, or better
- Internet connection (Cable/DSL speeds recommended)
- Ubuntu 12.04 LTS, fully updated
- Latest graphics driver
- NVidia driver support - For recent cards (e.g. series 8), you will need to install 310.x. For older cards, driver 304.x supports the NVidia 6 and 7 GPU series. To access these drivers, first update your cache and then install the specific [driver](https://support.steampowered.com/kb_article.php?ref=8509-RFXM-1964) you need from the list in Additional Drivers.
- AMD driver support - For recent cards (e.g. series 5 and above), we recommend installing the 12.11 driver. For older cards, Catalyst 12.6 supports the HD 2400 Pro card and is the latest for the 2 and 4 GPU series.
- Intel HD 3000/4000 driver support - you will need to use the latest Mesa drivers, Mesa 9 or later. For installation instructions, see [here](http://wiki.ubuntu.com/Valve).

Getting Started
---------------
Install the Steam for Linux client:

1. Download the steam.deb package from this [location](http://media.steampowered.com/client/installer/steam.deb).
2. Open a graphical file manager (for Ubuntu 12.04, click the folder icon on the Unity Launch bar).
3. Navigate to the directory containing steam.deb and double-click it. This launches Ubuntu Software Center and installs the package.
4. If you prefer to install from the command-line, use gdebi. Install the gdebi-core package (apt-get install gdebi-core) and then install the Steam for Linux package (gdebi steam.deb).
5. For a list of games supported by Steam for Linux either vist this [page](https://support.steampowered.com/kb_article.php?ref=8495-OKZC-0159) or click Store (from the client) and then the Linux tab on the far-right.
We recommend that you join the Steam for Linux official game group, located [here](http://steamcommunity.com/app/221410). You will find future beta announcements and other information posted here as well as an active discussion forum.

Reporting Issues
----------------

If you encounter an issue while using Steam for Linux or with any of the available Linux games, first search the [issue list](https://github.com/ValveSoftware/steam-for-linux/issues) to see if it has already been reported. Include closed issues in your search.

If it has not been reported, create a new issue with at least the following information:

- a short, descriptive title;
- a detailed description of the issue, including any output from the command line;
- steps for reproducing the issue; and
- your system information.\*

Please place logs either in a code block (press `M` in your browser for a GFM cheat sheet) or a [gist](https://gist.github.com).

\* The preferred and easiest way to get this information is from Steam's Hardware Information viewer from the menu (`About -> Hardware Information`). Once your information appears: right-click within the dialog, choose `Select All`, right-click again, and then choose `Copy`. Paste this information into your report, preferably in a code block.
