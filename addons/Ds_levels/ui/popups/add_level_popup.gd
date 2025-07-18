@tool
extends VBoxContainer


@onready var level_label_input: LineEdit = %level_label_input
@onready var level_path_picker: LineFilePicker = %level_path_picker

var data:LevelData
var storage:LevelDataStorage


func _ready() -> void:
	data = LevelData.new()
	
	level_label_input.text = data.label
	level_path_picker.start_path = data.level_path
	
	storage = LevelDataStorage.load_from_settings_path()

func _on_accept_button_pressed() -> void:
	if !data:
		PopupUtils.show_error_popup('Failed to add Level')
		return
	
	if !storage:
		PopupUtils.show_error_popup('Failed to add Level')
		return
	
	data.label = level_label_input.text
	data.level_path = level_path_picker.current_path
	
	storage.add_data(data)
	get_parent().queue_free()

func _on_cancel_button_pressed() -> void:
	get_parent().queue_free()
