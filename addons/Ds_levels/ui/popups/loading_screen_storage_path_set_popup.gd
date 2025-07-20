@tool
extends VBoxContainer


@onready var file_picker: LineFilePicker = %file_picker


func _ready() -> void:
	file_picker.current_path = LevelManagerPlugin.get_loading_screen_storage_path()
	

func _on_accept_button_pressed() -> void:
	LevelManagerPlugin.set_loading_screen_storage_path(file_picker.current_path)
	LoadingScreenDataStorage.save_at_settings_path()

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()
