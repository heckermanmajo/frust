--[[

Frust Roadmap.

The end-goal is a big nice game:
- base building like in EE & Crusader
- So many units like cossacks
- realism like in sudden strike
- map control like in supreme commander
- campaign map like in total war
- middle ages|fantasy|15-17th century|17-19th century|ww1|ww2|coldwar|modern|future

Game-Feeling:
- slow enough to be chill
- should feel real (real fire, smoke, explosions kill)
- units should think on their own, so you dont need tp micro manage

System-Relevance:
- base building makes more sense in medival times than in modern times
- modern base building is more capturingexsiting structures and building tactic fortifications

This is impossible to do at once, so we need to plit it up a lot.

The following release roadmap:
(Each game iteration gets is own repo and then is used
as basegame for the next iteration)


Anti Snowballing:
-----------------
How to prevent that a dominant player just snowballs?
- last stand money: after a player lost a lot he gets a last stand money to push back
- defender advantage: The defender has an advantage, since defense is always easier
- guerrilla warfare: The loosing side gets access to guerrilla units and tactics
    - guerrilla units spawn in some designated places of the map
    - can place bombs
    - on the mapo are civilians that can be killed but this gives the other player bonuses
    - you can "genocide" the civilian populations but the other player gets bonuses like moral boosts, etc.

Campaign Map
---------
- Pullback - Matches: If you get attacked by a very large army, you can choose
  to play a pullback game: This is a lengthy map in which you need to make it to the end
  to save your troopy, while the other army tries to inflict as much damage as possible
  You you need to choose some units to allow the retreat
- Last stand matches: You get some extra defense capabilities, so you
  can inflict extra damage on the opponent.
- every enemy final place has a strong last stand battle.
- diplomacy on the meta map and you can win in an alliance
- strong-alliances cannot be broken

Base Defenses
----------
- Defenses are structures which will be manned by units and increase the moral
- soldiers will automatically man the defenses and target the most important ones
- the game need to be slow enough so sandbags make snese to place

Frust Build 0.0
---------
- not too big maps (32*32 tiles)*3 * 3
- no advanced pathfinding (only astar)
- we can only do 3 pathfindings per frame
- but chunking (needed for efficient collision)
- map movement -> move the map with middle mouse
- Camera
- draw and collision protocol
- do random pathfindings
- do random obstacles
- scroll in/out
- debug info
- simple map loading -> use to non recursive repr functions
- place obstacles (user controller) (water/stone) [load and save]


Frust Build 1.0: First Gameplay
---------
- simple sounds -> load resources in the local files they belong to
- no building
- no campaign map
- no formations
- only modern age (simpler since no close combat)
- only 1v1
- circles in red|blue with weapons
- buy units via numbers 1-9
- unit control via mouse
- no control groups
- no menus
- simple collision detection (projectiles)
- one chunk as faction spawn

Frust Build 2.0: Smart Units
---------
- special stuff: granates, rpgs,
- units behave smart
- moral system
- explosions

Frust Build 3.0: Map Domination
---------
- get command points for map control
- minimap
- last stand money

Frust Build 4.0: cover
---------
- burnable objects
- place sandbags as cover

Frust Build 5.0: Vehicles
---------
- tanks same size, tanks rotate as one
- trucks & jeeps can transport units
- jeeps for fast capture

Frust Build 6.0: Navigation
---------
- display entrances & field clearance
- update of astar, so we only calc from chunk to chunk
  this allows us to have bigger maps
  Can a unit go from entrance to entrance? and from entrance to point
  where he currently is?

Frust Build 7.0: Fog of War
---------
- background black
- draw all fields of non visible chunks with 0.5 alpha
- dont draw units
- command units have higher vision

Frust Build 8.0: Actual AI
---------
- Ai manages its units and tries to counter
- ai tries different strategies of attack
- ai sends messages (pre recorded audio)

Frust Build 9.0: Placement of tactical structures
---------
- specific places where you can build stuff (like in battle for middle earth)
- specific resource places (like in starwars empire at war)
- free defense buildings (trenches, sanbads, mg nests, bunkers, towers, control points)

Frust Build 10.0:
---------


Longer distance Features:
- Building
- Formations
- Campaign Map (basically a new game)
- Menus
- More Ages
- air attacks (off map attacks)
- helicopter
- water units
- mines
- buildings
- resources/resource gathering (like C&C generals)


]]