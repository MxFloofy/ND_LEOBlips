Config = {
    enable_blips = true, -- If autoenable_blips is off you must use "/blip on" or "/blip off" to enable/disable the blips
    show_officer_on_foot = true,
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
}
