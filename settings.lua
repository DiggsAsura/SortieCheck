return {
    required_setup = {
        ['PLD'] = 'SCH',
        ['DNC'] = 'DRG',
        ['BRD'] = 'DRK',
        ['GEO'] = 'DRK',
        ['COR'] = 'DRK',
        ['RDM'] = 'DRK',
    },
    required_food = "Sublime Sushi", -- Sett navnet på maten du bruker her
    block_entry = true,
    overlay = {
        pos = {x = 500, y = 300},
        text = {size = 10, font = 'Consolas', alpha = 255},
        bg = {alpha = 150, visible = true},
        padding = 10 -- Gir luft rundt teksten
    }
}