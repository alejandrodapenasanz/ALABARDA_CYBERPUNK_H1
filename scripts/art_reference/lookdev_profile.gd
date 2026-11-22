extends Resource
## Valores de lookdev experimentales; no balance de juego ni límites finales.
@export var floor_color := Color("535751")
@export var wall_color := Color("354c50")
@export var metal_color := Color("74817b")
@export var dark_color := Color("161f24")
@export var warm_color := Color("af8749")
@export var terminal_color := Color("b6dca1")
@export var room_size := Vector3(12, 4.0, 10)
@export var ambient_neutral := 0.65
@export var ambient_atmospheric := 0.24
@export var ambient_alarm := 0.28
@export var key_neutral := 1.0
@export var key_atmospheric := 0.38
@export var key_alarm := 0.45
@export var local_energy := 1.8
@export var local_range := 6.5
@export var camera_positions := PackedVector3Array([Vector3(0, 2.05, 4.0), Vector3(-3.0, 1.55, 1.25), Vector3(0.2, 1.6, 3.5), Vector3(-1.4, 1.45, 1.55)])
@export var camera_targets := PackedVector3Array([Vector3(0, 1.4, -1.8), Vector3(-3.2, 1.2, -1.5), Vector3(0.2, 1.4, -1.2), Vector3(-1.4, 1.17, 0.1)])
