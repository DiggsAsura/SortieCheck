# SortieCheck

**SortieCheck** is a Final Fantasy XI addon for the **Windower 4** platform. It is specifically designed to assist players in verifying that all party members have the correct Job and Subjob combinations before entering **Sortie**.

## Features

* **Visual HUD:** A clean, semi-transparent overlay that shows all party members, their current jobs, and their readiness status.
* **Automatic Blocking:** Prevents you from entering Sortie (by clicking the *Diaphanous Gadget* in Kamihr Drifts) if any party member has an incorrect subjob.
* **Multibox Sync (IPC):** Uses Inter-Process Communication to reliably sync job information across multiple FFXI instances running on the same PC, bypassing the game's range-based subjob limitations.
* **Aligned UI:** A monospaced, column-based layout for high readability, similar to popular multibox management tools.
* **Configurable:** Easily define your preferred "Sortie Setup" in a simple configuration file.

## Installation

1. Create a folder named `SortieCheck` in your Windower `addons` directory.
2. Place `SortieCheck.lua`, `settings.lua`, and `README.md` inside that folder.
3. In-game, load the addon by typing:
   `//lua load sortiecheck` (or use `//send @all lua load sortiecheck` for multiboxing).

## Configuration

You can customize your required job setup by editing the `settings.lua` file. 

Example setup in settings.lua:
required_setup = {
    ['PLD'] = 'SCH', -- Player on PLD must have /SCH
    ['DNC'] = 'DRG', -- Player on DNC must have /DRG
    ['BRD'] = 'DRK', -- etc.
    ['GEO'] = 'DRK',
    ['COR'] = 'DRK',
    ['RDM'] = 'DRK',
}

## How it works

* **Green Text:** The player matches the required setup.
* **Red Text:** The player has a subjob that does not match the setup. Entry to Sortie will be blocked for the player interacting with the Gadget.
* **Grey Text:** The player is on a job not defined in your settings.lua.

## Commands

* //sc or //sortiecheck: General command prefix.
* //lua load sortiecheck: Loads the addon.
* //lua reload sortiecheck: Reloads the addon (use this after changing settings).
* //lua unload sortiecheck: Removes the overlay and stops the check.