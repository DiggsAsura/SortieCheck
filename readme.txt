=========================================
SORTIECHECK - README (v3.4)
=========================================

WHAT IS SORTIECHECK?
A logistical preparedness tool for Sortie that monitors party job setups, 
consumables, and inventory space.

KEY FEATURES:
- Visual HUD: Shows Name, Job/Sub, Pan, Echo, Holy, Rem, Food, and Inv space.
- Global Scan: Counts items in your main bag vs. total owned in all bags.
- Entry Blocking: Stops you from entering Sortie if subjobs are wrong.
- Multibox Sync: Shares data across all local FFXI windows via IPC.

HUD COLUMN LEGEND:
Name | Job/Sub | Pan | Echo | Holy | Rem | Food | Inv (Free Space)

COLOR CODING:
- Items/Food: Red (0-2), Orange (3-10), Green (11+).
- Inv (Space): Red (<10), Orange (<20), Green (20+).
- Jobs: Green if correct, Red if wrong.

COMMANDS:
//schk visible   - Show or hide the HUD.
//schk minimal   - Toggle a simple "READY" or "NOT READY" line.
//schk help      - Show in-game help menu.

INSTALLATION:
Place files in "addons/SortieCheck" and use "//lua load sortiecheck".
=========================================