# Lily's Mods
this is my big modpack that introduces some new mechanics that have been suggested in the Baba Is You discord before!

to install: extract the "Scripts" and "Sprites" folders into the world you wish to use the mod with - **make sure you have my modloader installed! (in [#assets-are-share](https://discordapp.com/channels/556333985882439680/560913551586492475/570613317782208513) pins on the [Baba Is You discord](https://discord.gg/GGbUUse))**

check `Scripts/options.lua` to enable or disable features

#### Nouns
- **ANY** - Checks for ANY object in conditions, acts as a random object elsewhere
- **GRAVITY** - Noun which affects the direction of gravity and more!

#### Verbs
- **MEANS** - Changes the definition of a noun or property
- **COPY** - Makes object copy another's movements

#### Properties
- **STICKY** - STICKY objects attach to other STICKY objects and move with them
- **BAIT** - Attracts LURE objects from afar in a + pattern
- **LURE** - Moves to BAIT objects from afar in a + pattern
- **TURN** - Makes object rotate CCW or CW (in options.lua) each turn
- **RESET** - Resets the level when a YOU touches it, like DEFEAT
- **PERSIST** - Makes object ignore UNDO
- **TIMELESS** - Applied to YOU, makes you (or other TIMELESS things) move around in stopped time until you wait
- **AUTO** - Makes object do certain things like movement on a timer instead of turns (requires particle effects??)
- **CUTE** - Heart effect
- **SOFT** - Prevents WEAK objects from dying on it (BABA IS CUTE AND SOFT)

#### Conditions
- **WITH** - True if object has all given properties
- **STILL** - True if object hasn't moved the past turn 
- **NEAREST** - True if object is closest to the given objects (using max distance)
- **TOUCH** - True if object is adjacent to given objects in a + pattern
- **🔁RESET** - True if a reset has happened
- **🔁EVEN** - True if the number of resets is even
- **🔁ODD** - True if the number of resets is odd
- **🔁COUNT** - True for the first N turns of a reset, where N is the number of resets
