@tool
extends Level2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		Levels.change_to_level_name('level 2', 'spawn')
