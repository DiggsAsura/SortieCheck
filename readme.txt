=========================================
SORTIECHECK - README (v1.9)
=========================================

WHAT IS SORTIECHECK?
SortieCheck is a Windower 4 addon for Final Fantasy XI that ensures all 
party members have the correct Job/Subjob combinations before entering 
Sortie.

KEY FEATURES:
- Visual HUD: Aligned, easy-to-read party status list.
- Minimal Mode: Clean, single-line status display.
- Entry Blocking: Automatically stops you from entering Sortie via the 
  Diaphanous Gadget if anyone has the wrong subjob.
- Multibox Sync: Shares job data between all local game windows (IPC).

COMMANDS:
//schk help     - Displays the in-game help menu.
//schk visible  - Toggles the overlay visibility (Show/Hide).
//schk minimal  - Toggles between Full List and Minimal Status line.

MINIMAL MODE:
When everything is correct (6/6 players with the right jobs), it displays:
"Sortie Ready Check: READY" in green text.

PREFIXES:
Use either //schk or //sortiecheck (//sc has been removed to avoid conflicts).

INSTALLATION:
1. Create a folder named "SortieCheck" in your windower/addons directory.
2. Place SortieCheck.lua and settings.lua inside that folder.
3. Load the addon in-game: //lua load sortiecheck

CONFIGURATION (SETTINGS.LUA):
Open settings.lua in a text editor to define your required job setup.
=========================================