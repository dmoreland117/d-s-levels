@tool
extends Level2D


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_left"):
		Levels.change_to_level(
			Levels.get_level_storage().get_data_by_label('lvl1'), 
			'dd', 
			{}
		)
