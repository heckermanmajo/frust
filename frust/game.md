# (GameName)

- [ ] Load the World map as a scene.
- [ ] Load different kinds of the world map to load different initial world data
- [ ] Campaign == editor(weil man noch den editor mode dazu hat) 
- [ ] Round based iteration of logic

- what values should exist?

## Code-style 
- document every function for types
- unit tests at the bottom of the file
- check all input-values -> protocol and other stuff 
- also check all reference checks

## Love 2d game engine
- animations: animations class like in nim
- logging into files
- Classes -> simple classes
- Serialisation
- refs -> check functions on each iteration
- load resources for each class in the class itself
- use interfaces in lua with simple check functions
- have type check functions in each function

### Protocol based programming
- protocols define what fields are needed to allow a certain operation (typed with emmylua)
- classes are the things that implement the protocols and actually exist
  - rule of thumb: a class can be serialized

### Camera
one global camera that is used to determine what to draw.

### Serialisation
- each class has a repr method that returns a string,
- each class has a from_repr method that takes a string and returns a class instance
- reprid()

### Performance 
- split stuff into chunks
- track all units per chunk
- draw everything chunk-based

### Debugging
--!debug:start
Code between these two lines will be removed in release mode
--!debug:end

- since we have serialisation from the start, we can use snapshot-tests to debug

### Scenes 
- from the start structure correctly
- zuse scenes to allow "sub-games" in the main game.
- rts scene, editor-scene
What is started, is determined by the command line arguments

main
  - editor
  - rts
  - campaign
  - directly start int some campaign menus
    - also make all actions via commands possible for testing

### UI-Folder 
- load different fonts at the start
- button, input, text, etc. 
- consuming buttons


