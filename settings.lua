return {
    required_setup = {
        ['PLD'] = 'SCH',
        ['DNC'] = 'DRG',
        ['BRD'] = 'DRK',
        ['GEO'] = 'DRK',
        ['COR'] = 'DRK',
        ['RDM'] = 'DRK',
    },
    block_entry = true,
    overlay = {
        pos = {x = 500, y = 300},
        text = {size = 12, font = 'Consolas', alpha = 255},
        bg = {alpha = 150, visible = true}, -- 0 = helt gjennomsiktig, 255 = helt sort
        padding = 12 -- Legger til luft på alle sider av teksten
    }
}