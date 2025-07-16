@tool
extends VBoxContainer


@onready var level_label_input: LineEdit = %level_label_input
@onready var level_description_input: LineEdit = %level_description_input
@onready var level_path_picker: LineFilePicker = %level_path_picker
@onready var show_level_loading_screen_input: CheckBox = %show_level_loading_screen_input
@onready var texture_file_picker: HBoxContainer = %texture_file_picker

var index:int = -1
var storage:LevelDataStorage
var data:LevelData


func _ready() -> void:
	storage = LevelDataStorage.load_from_settings_path()
	set_index(-1)
	
func set_index(idx:int):
	storage = LevelDataStorage.load_from_settings_path()
	
	index = idx

	if !storage:
		return
	
	if index == -1:
		data = null
	
		level_label_input.text = ''
		level_description_input.text = ''
		level_path_picker.current_path = ''
		show_level_loading_screen_input.toggle_mode = false
		return
	
	data = storage.get_data_by_index(index)
	
	level_label_input.text = data.label
	level_description_input.text = data.description
	level_path_picker.current_path = data.level_path
	show_level_loading_screen_input.toggle_mode = data.show_loading_screen

func _on_save_button_pressed() -> void:
	if !storage:
		return
		
	data.label = level_label_input.text
	data.description = level_description_input.text
	data.level_path = level_path_picker.current_path
	data.show_loading_screen = show_level_loading_screen_input.toggle_mode
	
	storage.edit_data(index, data)

func _on_reset_button_pressed() -> void:
	pass # Replace with function body.

func _on_clear_button_pressed() -> void:
	pass # Replace with function body.
