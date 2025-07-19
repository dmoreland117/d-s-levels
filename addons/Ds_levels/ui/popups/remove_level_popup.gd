@tool
extends VBoxContainer


@onready var level_name_label: Label = %level_name_label

var index:int


func _ready() -> void:
	if !LevelDataStorage.is_storage_loaded():
		return
	
	level_name_label.text = LevelDataStorage.get_data_by_index(index).label

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()

func _on_ok_button_pressed() -> void:
	LevelDataStorage.remove_data(index)
	get_parent().queue_free()
	
