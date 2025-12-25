# SortieCheck (v2.6)

**SortieCheck** is a Final Fantasy XI addon for the **Windower 4** platform. It verifies that all party members have the correct Job/Subjob combinations and sufficient consumables before entering **Sortie**.

## Features
* **Visual HUD:** Aligned, column-based overlay for high readability.
* **Consumable Tracking:** Real-time monitoring of Panacea, Echo Drops, Holy Water, and Remedy.
* **Color-Coded Status:**
    * **Items:** Green (11+), Orange (3-10), or Red (0-2).
    * **Jobs:** Green (OK), Red (Mismatch), or Grey (Not in setup).
* **Automatic Blocking:** Stops entry at the Diaphanous Gadget if the party is not ready.
* **Multibox Sync:** Shares data instantly across local instances via IPC.
* **Minimal Mode:** Toggles between a full list and a single "READY" line.

## Installation
1. Create a folder `addons/SortieCheck` in your Windower directory.
2. Place `SortieCheck.lua` and `settings.lua` inside.
3. Load in-game: `//lua load sortiecheck`.

## Commands
* `//schk help` - Displays the in-game help menu.
* `//schk visible` - Toggles HUD visibility.
* `//schk minimal` - Toggles between Full List and Minimal mode.
* `//schk debug` - Prints current inventory counts to chat.

## Columns Legend
Name | Job/Sub | Pan (Panacea) | Echo (Echo Drops) | Holy (Holy Water) | Rem (Remedy)