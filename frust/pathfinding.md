https://harablog.wordpress.com/2009/02/05/hierarchical-clearance-based-pathfinding/

https://harablog.wordpress.com/2009/01/29/clearance-based-pathfinding/


-> Nav graph retardius
Level 1: Wir brauchen die chunk-connection-parts.
- von links nach rechts, von oben nach unten.
- wenn einer pair keine connection ist weileiner von beiden geblockt ist 
  dann machen wir nix.
- Dann von anhand der clearence den "use"-node finden.
- Dann alle use nodes mit in einen graphen packen.
- Dann von den use nodes eines chunks, alle connections zu den use ndes aller anderen 
- seiten von den anderen chunks finden
- Dann filtern nach den pfaden die INSGESAMT die hoechste clearence haben.
  - von denen die kürzesten nehmen.
- dann die graphen visualisieren.


## Wir bruachen eine funktion die alles das aufruft wenn mann 
  einen obstacel change macht.
Map.computeHierarchicalAstar()