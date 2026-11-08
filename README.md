# Roblox Luau Flight Controller Script

A Roblox Luau flight script that lets a player toggle character flight with keyboard, touch, or gamepad controls, move horizontally with the default movement input, and ascend or descend while flying.

## Install

1. Open the experience in Roblox Studio.
2. In Explorer, open `StarterPlayer > StarterPlayerScripts`.
3. Insert a `LocalScript`.
4. Rename it to `FlightController`.
5. Copy the contents of `FlightController.client.lua` into the `LocalScript`.
6. Press Play to test the controls.

The script must run as a `LocalScript` because it reads local player input and controls the local character.

## Use

- Press `F` to toggle flight on or off.
- Use `W`, `A`, `S`, and `D` to move horizontally while flying.
- Hold `Space` to ascend.
- Hold `LeftControl` to descend.
- On mobile, use the generated `Fly`, `Up`, and `Down` touch buttons with the default movement thumbstick.
- On a gamepad, press `Y` to toggle flight, `A` to ascend, and `B` to descend.
- Change `FLIGHT_SPEED` near the top of the script to adjust the flight speed. The default is `56` studs per second.

The script uses `LinearVelocity`, preserves and restores the humanoid's original autorotation setting, and removes its flight objects when flight stops, the character dies, the player respawns, or the script is destroyed.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/fc34c095-e7a8-4284-a328-fc693e0fec8d?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=fc34c095-e7a8-4284-a328-fc693e0fec8d
