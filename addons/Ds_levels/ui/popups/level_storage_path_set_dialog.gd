@tool
extends VBoxContainer


@onready var file_picker: HBoxContainer = %file_picker

var start_path:String = ''
var current_path:String = ''


func _ready() -> void:
	start_path = LevelManagerPlugin.get_levels_storage_path()
	current_path = start_path
	file_picker.start_path = start_path

func _on_file_picker_path_changed(path: String) -> void:
	current_path = path

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()

func _on_accept_button_pressed() -> void:
	LevelManagerPlugin.set_levels_storage_path(current_path)
	LevelDataStorage.save_at_settings_path()
	get_parent().queue_free()
