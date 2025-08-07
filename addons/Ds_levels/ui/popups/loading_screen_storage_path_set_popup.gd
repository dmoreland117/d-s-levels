@tool
extends VBoxContainer


@onready var file_picker: LineFilePicker = %file_picker
@onready var accept_button: Button = $HBoxContainer/accept_button


func _ready() -> void:
	file_picker.start_path = LevelManagerPlugin.get_loading_screen_storage_path()

func _on_accept_button_pressed() -> void:
	LevelManagerPlugin.set_loading_screen_storage_path(file_picker.current_path)
	if !LevelDataStorage.load_from_settings_path():
		LoadingScreenDataStorage.save_at_settings_path()
	
	get_parent().queue_free()

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()

func _on_file_picker_path_selected(path: String) -> void:
	get_parent().show()
	if !ResourceLoader.exists(path):
		accept_button.text = 'Create'
		return
	
	accept_button.text = 'Load'
func _on_file_picker_cancled() -> void:
	get_parent().show()
