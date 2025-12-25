# SortieCheck

**SortieCheck** is a Final Fantasy XI addon for Windower 4. It verifies that all party members have the correct Job/Subjob combinations before entering **Sortie**.

## Features
* **Visual HUD:** Aligned column-based overlay.
* **Minimal Mode:** Toggle between full party list or a single "READY" line.
* **Automatic Blocking:** Prevents interaction with the *Diaphanous Gadget* if subjobs are wrong.
* **Multibox Sync:** Shares job data across local instances via IPC.

## Commands
* `//schk help` - Shows the in-game help menu.
* `//schk visible` - Shows or hides the overlay.
* `//schk minimal` - Toggles between full list and minimal mode.
* `//sortiecheck` - (Alternative prefix).

## Installation
1. Create a folder `addons/SortieCheck`.
2. Save `SortieCheck.lua` and `settings.lua` in that folder.
3. Load with `//lua load sortiecheck`.