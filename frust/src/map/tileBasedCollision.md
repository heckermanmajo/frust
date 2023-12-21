# Tile Based Collision

Each soldier has a tile as position.
He only moves if the next tile is free.
-> He marks the free tile as "occupied" before he moves.
-> after he has moved there, he marks the old tile as "free" again.
-> Projectiles are not on a tile, but at a chunk, since 
   their collision is only one-directional.
-> so they can simply get the tile they are on via hash and 
   check if it is free or not. if not they do the collision-logic.