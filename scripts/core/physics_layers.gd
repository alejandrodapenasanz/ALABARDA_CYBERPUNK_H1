class_name PhysicsLayers
extends RefCounted
## Physics layer bit values shared by player and combat scenes.
## Layer 1 world is Godot's default, so H1/H04 geometry keeps working unchanged.

const WORLD := 1          # layer 1: static geometry, interactables
const PLAYER := 2         # layer 2: player body
const ENEMY := 4          # layer 3: enemy/dummy bodies
const HITBOX := 8         # layer 4: Area3D hitboxes (head/body zones)
