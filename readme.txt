=========================================
SORTIECHECK - README (v2.6)
=========================================

WHAT IS SORTIECHECK?
A Windower 4 addon for FFXI that ensures your party is fully prepared 
for Sortie by checking both job setups and consumable stocks.

KEY FEATURES:
- HUD Overlay: Displays party names, jobs, and item counts (Pan, Echo, Holy, Rem).
- Color Alerts: Items turn Red if you have 0-2 left, Orange for 3-10, and Green for 11+.
- Entry Security: Blocks entry to Sortie if someone has the wrong subjob or the party is incomplete.
- Multibox Ready: Syncs data instantly between all local FFXI windows using IPC.

COMMANDS:
//schk help     - Shows help menu.
//schk visible  - Shows/Hides the overlay.
//schk minimal  - Toggles simple "READY" or "NOT READY" mode.
//schk debug    - Verifies item counts in the chat log.

INSTALLATION:
Place files in "addons/SortieCheck" and use "//lua load sortiecheck".

CONFIG:
Modify required job/subjob combinations in settings.lua.
=========================================