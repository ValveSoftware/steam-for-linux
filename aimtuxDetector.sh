#========= Copyright © 2017, Valve LLC, All rights reserved. =================
#
# Purpose: 
# Detecting Cheating scum using the AimTux Cheat for CSGO
#
#=============================================================================

#!/bin/sh
grep -i aimtux /proc/$(pidof csgo_linux64)/maps