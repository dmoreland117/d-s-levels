class_name LevelContainer3D
extends Node3D


const LEVEL_NODE_INDEX = 3

var level:Level3D: set = set_level


func _ready() -> void:
	Levels._set_level_container(self)
	Levels.change_to_start_level('start', {})

func set_level(level:Level3D) -> bool:
	if get_child_count() >= 4:
		get_child(LEVEL_NODE_INDEX).queue_free()
	
	if !level:
		return false
	
	add_child(level)
	return true
