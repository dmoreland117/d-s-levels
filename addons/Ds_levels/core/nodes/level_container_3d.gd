class_name LevelContainer3D
extends Node3D


var level:Level3D: set = set_level


func _ready() -> void:
	Levels._set_level_container(self)
	Levels.change_to_start_level('start', {})

func set_level(level:Level3D) -> bool:
	if get_child_count() >= 2:
		get_child(1).queue_free()
	
	if !level:
		return false
	
	add_child(level)
	return true
