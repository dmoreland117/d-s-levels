@tool
extends VBoxContainer


@onready var level_name_label: Label = %level_name_label

var index:int
var storage:LevelDataStorage


func _ready() -> void:
	storage = LevelDataStorage.load_from_settings_path()
	if !storage:
		return
	
	level_name_label.text = storage.get_data_by_index(index).label

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()

func _on_ok_button_pressed() -> void:
	storage.remove_data(index)
	get_parent().queue_free()
	
