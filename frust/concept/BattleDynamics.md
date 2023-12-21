## Battle dynamics

Erstmal ein RTS bauen das in sich spaß macht, dann eine Kampanenkarte draufsetzen.

Da es sich um ein RTS handelt, sind die Battle dynamics der kern des game plays.


Folgendes sind die Leitprinzipien:
1. Defensive Lohnt sich 
2. Ai ist smart, vielseitig und Koop mit ai ist fein
3. Die Ai unterliegt den selben regeln wie der spieler
4. Explosionen und Waffen machen realistischen schaden (kein schere stein papier)
5. Einzelne units sind schlau und haben unterschiedliche "Selbstverwaltungsmodi"
6. Spezialfähigkeiten werden automatisch eingesetzt (wie z.b. granaten werfen)
7. Alle Ressourcen auf der Map werden in Kommando-Punkte umgewandelt
8. Ressourcen können eingesammelt werden (ölfässer, kisten) oder durch das halten von Gebäuden generiert werden
9. Es gibt ein Moral-System, einheiten können zur flucht gebracht werden und festgenagelt werden (durch zu viel feuer)
10. Einheiten rennen nicht einfach in den tod, sie suchen deckung und versuchen sich zu verteidigen
11. Moralboost durch vebund mit support units & panzern
12. Focus auf das wirken von schlachten (viele death sprites, einschlaglöcher bleiben, zerstörung des umfelds, realistisches feuer)
13. Projektile fliegen mit abweichung über entfernung 
14. Projektile bleiben an halb deckung mit wahrscheinlichkeit hängen (jenach dem wie lange das projectile schon geflogen ist)
15. Das gameplay soll für coole schlachten optimieren
    -> nicht zu defensiv, aber nicht zu offensiv
16. Es gibt keine "super units" die alles können
17. Es gibt taktische Nuklearwaffen und Haubitzen, die sind aber dementsprechend teuer
18. Es gibt last stand kommando-punkte, so dass man wenn es sich gegen einen wendet
    ein einziges mal eine gegenoffensive starten kann 
19. Einheiten der Fraktionen sehen anders aus: grau, grün, sand, blau, also max 4 teams. Teamfarben nur innerhalb einer Fraktion. 
20. Keine Technologie/Upgrades man kann gleich alles bauen.
21. Einheiten wirken besser im verbund: Panzer steigern moral der Infantrie, panzer ohne infantrie sind anfällig für infantrie
22. Panzerfäuste können auch gegen zum beispiel mg stellungen eingesetzt werden, usw.


Die Stats der einheiten sind in einer datei festgelegt, später mit der Campaign map 
kann man sie dann aufrüsten, welche freischalten, usw.

- geschoss-logik
- Bewegung in gruppen
- zusammenfassen in squads
- Ai-verhalten (der units)
- Ai verhalten der Fraktions-Gegner


- Alle daten müssen in die Map integriert werden.