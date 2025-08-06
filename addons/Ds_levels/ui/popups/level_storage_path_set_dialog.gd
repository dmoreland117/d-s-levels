@tool
extends VBoxContainer


@onready var file_picker: HBoxContainer = %file_picker


func _ready() -> void:
	file_picker.start_path = LevelManagerPlugin.get_levels_storage_path()

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()

func _on_accept_button_pressed() -> void:
	LevelManagerPlugin.set_levels_storage_path(file_picker.current_path)
	LevelDataStorage.save_at_settings_path()
	get_parent().queue_free()

func _on_file_picker_path_selected(path: String) -> void:
	get_parent().show()
