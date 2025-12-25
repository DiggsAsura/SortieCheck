# SortieCheck (v3.4)

**SortieCheck** is a Final Fantasy XI addon for the **Windower 4** platform designed to ensure party readiness for **Sortie**. It monitors job setups, consumables, and inventory space across all party members using IPC.

## Features

* **Detailed HUD:** Displays party status including names, job combinations, and essential item counts.
* **Global Item Tracking:** Monitors Panacea, Echo Drops, Holy Water, Remedy, and a customizable Food item.
* **Dual-Count Logistics:** Displays items as `Inventory (Total Owned)` to show stock across all storage bags (Sack, Satchel, Wardrobes, etc.).
* **Inventory Monitoring:** Tracks free slots in each player's main inventory bag.
* **Entry Security:** Automatically blocks interaction with the *Diaphanous Gadget* if subjobs are incorrect or party members are not ready.
* **Multibox Integration:** Synchronizes data instantly between local game instances via IPC.

## Color Indicators

* **Items & Food:** * **Red:** 0–2 items.
    * **Orange:** 3–10 items.
    * **Green:** 11+ items.
* **Inv (Free Space):** * **Red:** Less than 10 slots available.
    * **Orange:** Less than 20 slots available.
    * **Green:** 20 or more slots available.
* **Jobs:** Green if matching the `settings.lua` configuration, Red if mismatched.

## Commands

* `//schk visible` — Toggles HUD visibility.
* `//schk minimal` — Toggles between a full detailed list and a single-line "READY" status.
* `//schk help` — Displays the in-game help menu.

## Configuration

Customize your required job setups and food choice in `settings.lua`.