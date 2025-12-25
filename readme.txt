=========================================
SORTIECHECK - README
=========================================

WHAT IS SORTIECHECK?
SortieCheck is a Windower 4 addon for Final Fantasy XI that helps you verify 
that all party members have the correct Job/Subjob combination before 
entering Sortie.

KEY FEATURES:
- In-game overlay showing the status of all party members.
- Automatically blocks entrance (Diaphanous Gadget) if anyone has the 
  wrong subjob.
- Perfect for multiboxing by syncing data between your game windows (IPC).
- Clean, column-based layout for easy readability.

INSTALLATION:
1. Create a folder named "SortieCheck" in your windower/addons directory.
2. Place SortieCheck.lua and settings.lua inside that folder.
3. Load the addon in-game using the command: //lua load sortiecheck

HOW TO READ THE OVERLAY:
- Green text: Everything is OK.
- Red text: Wrong subjob detected (Entry will be blocked).
- Grey text: The job is not defined in your configuration.

COMMANDS:
//lua load sortiecheck   - Loads the addon.
//lua reload sortiecheck - Updates the addon (use this after changing settings).
//lua unload sortiecheck - Stops the addon and removes the overlay.

CONFIGURATION (SETTINGS.LUA):
You can change the required subjobs by opening settings.lua in a text editor.
The default setup is:
PLD/SCH, DNC/DRG, BRD/DRK, GEO/DRK, COR/DRK, RDM/DRK.
=========================================