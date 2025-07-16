class_name LevelContainer2D
extends Node2D


var level:Level2D: set = set_level


func set_level(level:Level2D) -> bool:
	if !get_child_count() >= 1:
		return false
	
	get_child(0).queue_free()
	
	if !level:
		return false
	
	add_child(level)
	return true
