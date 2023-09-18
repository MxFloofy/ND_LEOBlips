Config = {
    enable_blips = true, -- If autoenable_blips is off you must use "/blip on" or "/blip off" to enable/disable the blips
    UseCharName = true, -- If false will use fivem/steam name
    disable_show_officer_on_foot = false, -- If true will only show when in vehicle
    autoenable_blips = true, -- If set true every 15 seconds it will check players jobs to see if they are in one of the departments below. /blip off will not work if using this (as of now)

    -- The number value here (30) is the blip colour, use the blip data link below to find out what number = what colour.
    departments = {
        ['LSPD'] = {29},
        ['BCSO'] = {25},
        ['SAHP'] = {54},
        ['LSFD'] = {1},
    },

    -- BLIP SETTINGS --
    -- Blip data https://docs.fivem.net/docs/game-references/blips/ -- 
    blipcone = true,
    HeadingIndicator = true,
    blipscale = 1.0,
    leofootblip = 60,
    helicopterblip = 43,
    boatblip = 754,
    motorcycleblip = 226,
    planeblip = 307,
    vehicleblip = 56,
    blipcategory = 1, -- 1 = No distance shown in legend | 2 = Distance shown in legend | 7 = "Other Players" category, also shows distance in legend
}