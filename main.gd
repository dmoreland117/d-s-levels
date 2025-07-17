extends Node2D
@onready var level_container_2d: LevelContainer2D = $LevelContainer2D


func _ready() -> void:
	var l = Levels.get_levels()
	Levels.change_to_level(
		Levels.get_level_storage().get_data_by_label('lvl2'), 
		'dd', 
		{}
	)
