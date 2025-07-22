@tool
extends Control


signal data_changed(index:int, data:Dictionary)
signal remove_pressed(index:int)

@onready var loading_screen_label_input: LineEdit = %loading_screen_label_input
@onready var loading_screen_path_picker: LineFilePicker = %loading_screen_path_picker

var edit_mode:bool

var screen_data:Dictionary = {}


func _ready() -> void:
	loading_screen_label_input.text = screen_data.get('label', '[Error]')
	loading_screen_path_picker.start_path = screen_data.get('path', '[Error]')

func _on_remove_button_pressed() -> void:
	remove_pressed.emit(get_index())

func _on_loading_screen_path_picker_path_selected(path: String) -> void:
	data_changed.emit(get_index(), {
			'label': loading_screen_label_input.text,
			'path': path
		})

func _on_loading_screen_label_input_editing_toggled(toggled_on: bool) -> void:
	if toggled_on:
		return
	
	data_changed.emit(get_index(), {
			'label': loading_screen_label_input.text,
			'path': loading_screen_path_picker.current_path
		})
