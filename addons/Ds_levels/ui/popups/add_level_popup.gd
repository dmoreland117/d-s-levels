@tool
extends VBoxContainer


@onready var level_label_input: LineEdit = %level_label_input
@onready var level_path_picker: LineFilePicker = %level_path_picker

var data:LevelData


func _ready() -> void:
	data = LevelData.new()
	
	level_label_input.text = data.label
	level_path_picker.start_path = data.level_path
	
func _on_accept_button_pressed() -> void:
	if !data:
		PopupUtils.show_error_popup('Failed to add Level')
		return
	
	if !LevelDataStorage.is_storage_loaded():
		PopupUtils.show_error_popup('Failed to add Level')
		return
	
	data.label = level_label_input.text
	data.level_path = level_path_picker.current_path
	
	LevelDataStorage.add_data(data)
	get_parent().queue_free()

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()
