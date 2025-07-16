class_name LevelContainer2D
extends Node2D


var level:Level2D: set = set_level


func _ready() -> void:
	Levels._set_level_container(self)

func set_level(level:Level2D) -> bool:
	if get_child_count() >= 2:
		get_child(1).queue_free()
	
	if !level:
		return false
	
	add_child(level)
	return true
