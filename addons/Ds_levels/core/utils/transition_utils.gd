class_name TransitionUtils


const DEFAULT_TRANSITION_PATH = "res://addons/Ds_levels/level_transitions/default_transition.tscn"


static func create_transition_instance(index:int, speed_scale:float = 1.0) -> LevelTransition:
	# TODO: Get the real path from storage that i still need to create
	
	if index == -1:
		return
	
	var path = DEFAULT_TRANSITION_PATH
	var scene:PackedScene = load(path)
	var instance:LevelTransition
	
	if !scene:
		printerr('Failed to load the LevelTransition at path %s' % path)
		return
	
	instance = scene.instantiate()
	instance.speed_scale = speed_scale
	
	return instance
