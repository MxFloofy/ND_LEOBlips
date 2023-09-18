# ND_Blips

This script provides a law enforcement blip system for your FiveM server. It allows law enforcement officers to have blips displayed on the map based on their department and vehicle status.

## Features

- Automatic blip updates for law enforcement officers based on their department and vehicle status.
- Toggleable blips using the `/blip on` and `/blip off` chat commands.
- Customizable blip settings, including color, scale, and blip category.
- Supports displaying blips for various law enforcement departments and vehicle classes.
- Live Siren Alerts with the blip flashing from red and blue if Siren is on.

## Configuration

The script provides a `Config` table in the Lua script file (`blip_system.lua`). The configuration includes the following options:

- `enable_blips`: Enable or disable the blip system. If disabled, players won't receive blips regardless of the `/blip` command.
- `UseCharName`: If set to `true`, blips will display the character's first and last name. If `false`, it will use the FiveM/Steam name.
- `disable_show_officer_on_foot`: If set to `true`, blips will only be shown when the officer is in a vehicle.
- `autoenable_blips`: If set to `true`, blips will automatically be enabled for law enforcement officers every 15 seconds.
- `departments`: A table that defines law enforcement departments and their corresponding blip colors.

### Blip Settings

The script allows you to customize various blip settings:

- `blipcone`: Display a cone on the blip to indicate the direction the player is facing.
- `HeadingIndicator`: Show a heading indicator on the blip.
- `blipscale`: The scale of the blips on the map.
- `leofootblip`: Blip sprite ID for law enforcement officers on foot.
- `helicopterblip`: Blip sprite ID for helicopters.
- `boatblip`: Blip sprite ID for boats.
- `motorcycleblip`: Blip sprite ID for motorcycles.
- `planeblip`: Blip sprite ID for planes.
- `vehicleblip`: Blip sprite ID for other vehicles.
- `blipcategory`: Blip category ID for the blips.

## Dependancies

1. Download|Install[ND_Core](https://github.com/ND-Framework/ND_Core
2. Download|Install [ND_Characters](https://github.com/ND-Framework/ND_Characters

## Chat Commands

- `/blip on`: Enable blips for law enforcement officers.
- `/blip off`: Disable blips for law enforcement officers.

## Notes

- Make sure to configure the `Config.departments` table to match your server's law enforcement departments and their corresponding blip colors.
- The blip system supports automatic blip updates every 15 seconds (if `autoenable_blips` is `true`), and manual toggling using the `/blip` chat command.

For more information about the blip settings and how to use this script, refer to the script comments and documentation provided in the Lua script file (`client.lua | config.lua`).


### Special Thanks To https://github.com/TheStoicBear for keeping this up and updating it while my github was down
