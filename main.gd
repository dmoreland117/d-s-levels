extends Node3D
@onready var level_container_2d: LevelContainer3D = $LevelContainer3D


func _ready() -> void:
	var l = Levels.get_level_storage()
	Levels.change_to_level(
		Levels.get_level_storage().get_data_by_label('lvl1'), 
		'dd', 
		{}
	)
