@tool
class_name Level3D
extends Node3D


signal level_start(args:LevelChangeData)

@export var level_name:String = ''
@export var environment:Environment: set = set_environment
## If set this scene will be loadied instead of the path defined in the levels tab
@export_file('*.tscn') var player_scene_path_override:String

var level_change_data:LevelChangeData

var current_spawn_point_node:SpawnPoint3D
var world_environment:WorldEnvironment
var player_instance:Node


func _ready() -> void:
	if !_add_world_env():
		printerr('Faild to create WorldEnvironment')
		return
	
	if Engine.is_editor_hint():
		_set_current_spawn_point()
		_set_up_player()
		return
	
	if !level_change_data:
		printerr('Level_change_args is null')
		return
	
	level_start.emit(level_change_data)
	
	if !_set_current_spawn_point():
		printerr('Failed to load current spawn point')
		return
	
	if ! _set_up_player():
		printerr('Faild to create Player')
		return

## Set the [Environment] for the Level's [WorldEnvironment]
func set_environment(env:Environment):
	environment = env
	
	if !world_environment:
		return
	
	world_environment.environment = env

## Returns all of the [SpawnPoint2D]s in the Level.
func get_spawn_points() -> Array:
	return LevelNodeUtils.get_spawn_points(self)

## Returns the [LevelChangeData] for the Level
func get_level_change_data() -> LevelChangeData:
	if !level_change_data:
		return
	
	return level_change_data

func get_level_data():
	if !level_change_data:
		return
	
	return level_change_data.level_data

## Returns the currently spawned Player.
func get_player() -> Node:
	if !player_instance:
		return
	
	return player_instance

func get_sun() -> DirectionalLight3D:
	return LevelNodeUtils.get_directional_light(self)

func _add_world_env() -> bool:
	if !LevelNodeUtils.has_world_environment(self):
		world_environment = LevelNodeUtils.create_world_environment(environment)
		
		if !world_environment:
			return false
		
		add_child(world_environment)
		return true
	
	world_environment = LevelNodeUtils.get_world_environment(self)
	environment = world_environment.environment
	return true

func _set_current_spawn_point() -> bool:
	if !level_change_data and !Engine.is_editor_hint():
		printerr('Level_change_data.spawn_point is null')
		return false
	
	if !Engine.is_editor_hint():
		current_spawn_point_node = LevelNodeUtils.get_current_spawn_point(
			get_spawn_points(), 
			level_change_data.spawn_point
		)
	else:
		current_spawn_point_node = LevelNodeUtils.get_current_spawn_point(
			get_spawn_points(), 
			'default'
		)
	
	if !current_spawn_point_node:
		return false
	
	return true

func _set_up_player() -> bool:
	if !LevelDataStorage.is_storage_loaded():
		printerr('storage is not loaded')
		return false
	
	var player_path
	
	if player_scene_path_override:
		player_path = player_scene_path_override
	else:
		player_path = LevelDataStorage.get_player_scene_path()
	
	if !player_path or player_path.is_empty():
		printerr('player_path is null')
		return false
	
	player_instance = LevelNodeUtils.create_player(player_path, current_spawn_point_node)
	if !player_instance:
			return false
	
	if Engine.is_editor_hint():
		current_spawn_point_node.add_child(player_instance)
		return true
		
	add_child(player_instance)
	
	return true
