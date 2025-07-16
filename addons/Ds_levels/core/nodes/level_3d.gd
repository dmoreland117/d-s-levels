class_name Level3D
extends Node3D


signal level_start(args:Dictionary)

@export var environment:Environment
## If set this scene will be loadied instead of the path defined in the levels tab
@export_file('*.tscn') var player_scene_path_override:String

var level_change_args:Dictionary

var current_spawn_point_node:SpawnPoint2D
var world_environment:WorldEnvironment


func _ready() -> void:
	pass

func set_current_spawn_point() -> bool:
	return true

func get_level_change_args() -> Dictionary:
	return {}

func set_world_environment(env:Environment) -> bool:
	return true
