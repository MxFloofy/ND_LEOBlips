Config = {
    enable_blips = true, -- If autoenable_blips is off you must use "/blip on" or "/blip off" to enable/disable the blips
    UseCharName = true, -- If false will use fivem/steam name
    show_officer_on_foot = true, -- If false will only show when in vehicle
    autoenable_blips = true, -- If set true every 15 seconds it will check players jobs to see if they are in one of the departments below. /blip off will not work if using this (as of now)
    departments = {
        "LSPD",
        "BSCO",
        "SAFR",
        "SAHP"
    },

    -- BLIP SETTINGS --
    -- Blip data https://docs.fivem.net/docs/game-references/blips/ -- 
    blipcone = true,
    HeadingIndicator = true,
    blipcolor = 30,
    blipscale = 1.0,
    leofootblip = 1,
    helicopterblip = 64,
    boatblip = 427,
    motorcycleblip = 226,
    planeblip = 423,
    vehicleblip = 227,
    blipcategory = 7, -- 1 = No distance shown in legend | 2 = Distance shown in legend | 7 = "Other Players" category, also shows distance in legend
}
