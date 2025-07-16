class_name LevelContainer3D
extends Node3D


var level:Level3D: set = set_level


func set_level(level:Level3D) -> bool:
	if !get_child_count() >= 1:
		return false
	
	get_child(0).queue_free()
	
	if !level:
		return false
	
	add_child(level)
	return true
