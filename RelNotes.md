Steam for Linux Release Notes
-----------------------------
(last update: 02/06/13)

The following issues are known by Valve and might impact users of the Steam for Linux client. For more information, see the Steam for Linux official game [group](http://steamcommunity.com/app/221410) and the Steam for Linux support [site](https://support.steampowered.com/kb_cat.php?id=97).

Installation
------------
* Installing the Steam for Linux .deb package on Kubuntu 64 bit requires **gdebi**. First, install the **gdebi-core** package ( **apt-get install gdebi-core**) and then install the Steam for Linux package ( **gdebi steam.deb**).
* Steam for Linux currently supports over 30 games. There are plans for adding other games in the future. For a complete list of supported games, see [here](https://support.steampowered.com/kb_article.php?ref=8495-OKZC-0159).
* Application files installed by Steam for Linux should not be shared (e.g. between Windows and Linux). This is a requirement of the Steam for Linux client.

Graphics
--------
* Steam currently disables the (deprecated) XF86DGA mouse extension. This may degrade high-speed mouse behavior at low frame rates in games that would otherwise use this extension. This mostly affects games using the libSDL1.2 library. Games using libSDL2 use the newer XInput2 extension instead.
* Poor performance with NVidia graphics cards can result if **Sync to VBlank** (aka VSync) is enabled. This option is found in the NVIDIA X Server Settings dialog box. From the **Unity Dash**, type "nv" and then choose **NVIDIA X Server Settings**. Click **OpenGL Settings** and then uncheck **Sync to VBlank**.
* The Catalyst 12.11 AMD graphics card driver is currently in the "precise-proposed" repository and hasn't been promoted at this time. This is part of a vetting process controlled by Canonical. You can enable this repository by opening **Ubuntu Software Center**, selecting **Edit** | **Software sources...** and then enabling the **Pre-released updates** option on the **Updates** tab.
* In some cases, jockey-text -l causes a crash. The crash fix is in "precise-proposed" and hasn't been promoted out of that yet. This is part of a vetting process controlled by Canonical.

Audio
-----
* There has been an AMD driver release that fixes a bug for users running on an AMD Radeon HD 7000 series graphics card. You can get the latest driver by enabling the **precise-proposed** repository. For more information, see the previous **Graphics** section.

Desktop Environment
-------------------
* If you are using CompizConfig Settings Manager (CCSM) there are several issues you should be aware of. You can determine if this is installed by opening the Unity HUD and typing "ccsm".
  * Performance for games running in full-screen mode can be improved by checking the **Undirect Fullscreen Windows** option (located by clicking the CCSM: Composite button from the main page). This prevents CCSM from drawing each frame off-screen and then copying to the active window. For more information, see [here](http://askubuntu.com/questions/99228/does-unredirect-fullscreen-window).
  * If you have multiple monitors and are running CCSM, enabling the **Undirect Fullscreen Windows** option has no effect.
  * Performance for games running in windowed mode are affected by some settings in CCSM and Unity. To improve performance, use a desktop environment other than Unity.
* For Ubuntu 12.04, the default behavior of the Alt key displays the Unity HUD. If pressed during game play, this forces the game screen to be minimized. The solution is to disable or remap the Alt key by using the **Shortcuts** tab on the Keyboard dialog. For more information, see [here](http://askubuntu.com/questions/122209/how-do-i-modify-or-disable-the-huds-use-of-the-alt-key).
* If you are using Unity 3D with an NVIDIA card, install the 310.14 driver. This driver has workarounds for extreme jitter in OpenGL applications (only applies to windowed applications if you have **Undirect Fullscreen Windows** enabled in CCSM) and additional fixes for Steam client performance.
* If you are using the KDE desktop, you can improve Team Fortress 2 performance by disabling desktop effects (using the **Advanced** tab of the **System Settings** | **Desktop Effects**) or suspending desktop compositing (**Alt** + **Shift** + **F12**). Failure to do so will result in frame time jitter as well as performance problems when the game is running composited (i.e. windowed or **Undirect Fullscreen Windows** disabled). Another solution is to install the following [patch](https://projects.kde.org/projects/kde/kde-workspace/repository/revisions/20e6349843d9bb838673a301330d7dc5d08401a5) or to use KDE 4.9.3 or later.
* After installing Steam for Linux (on Ubuntu 12.04 with the Unity desktop environment) the icon created on the Unity Launcher is incorrect. This is an Ubuntu bug. The proper icon (the Steam gear shaft icon) appears after rebooting the machine.
