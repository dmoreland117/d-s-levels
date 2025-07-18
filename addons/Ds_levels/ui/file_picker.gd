@tool
class_name LineFilePicker
extends HBoxContainer


signal path_selected(path:String)
signal path_changed(path:String)

@onready var path_input: LineEdit = %path_input
@onready var file_button: Button = %file_button
@onready var file_dialog: FileDialog = %FileDialog

@export var placeholder_text:String = '':
	set(val):
		placeholder_text = val
		if path_input:
			path_input.placeholder_text = val
@export var start_path:String = 'res://':
	set(val):
		start_path = val
		if path_input:
			path_input.text = val
		
		current_path = val
@export_enum('Open File:0', 'Open Dir:2') var file_mode:int

var current_path:String:
	set(val):
		current_path = val
		_update_line_edit_text()


func _ready() -> void:
	if !_check_nodes():
		return
	
	current_path = start_path
	file_dialog.current_path = current_path
	file_dialog.file_mode = file_mode
	path_input.placeholder_text = placeholder_text

func _check_nodes() -> bool:
	if !file_dialog:
		return false
	
	if !path_input:
		return false
	
	return true

func _update_line_edit_text():
	if !path_input:
		return
		
	path_input.text = current_path

func _on_path_input_text_changed(new_text: String) -> void:
	current_path = new_text
	path_changed.emit(current_path)
	
func _on_path_input_text_submitted(new_text: String) -> void:
	path_selected.emit(current_path)

func _on_file_dialog_dir_selected(dir: String) -> void:
	current_path = dir
	path_selected.emit(current_path)
	path_changed.emit(current_path)
	
func _on_file_dialog_file_selected(path: String) -> void:
	current_path = path
	path_selected.emit(current_path)
	path_changed.emit(current_path)
	_update_line_edit_text()
	
func _on_file_button_pressed() -> void:
	file_dialog.show()
