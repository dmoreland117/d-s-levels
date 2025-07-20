class_name LevelContainer2D
extends Node2D


var level:Level2D: set = set_level


func _ready() -> void:
	Levels._set_level_container(self)
	Levels.change_to_start_level('start', {})

func set_level(level:Level2D) -> bool:
	if get_child_count() >= 3:
		get_child(2).queue_free()
	
	if !level:
		return false
	
	add_child(level)
	return true
