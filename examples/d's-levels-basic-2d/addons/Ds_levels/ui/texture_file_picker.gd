@tool
extends HBoxContainer


signal path_changed(path:String)
signal path_selected(path:String)

@onready var texture_rext: TextureRect = %texture_rext
@onready var file_picker: LineFilePicker = %file_picker

@export var start_path:String:
	set(val):
		start_path = val
		current_path = val
		
		_update_texture()
		
		if !file_picker:
			return
		
		file_picker.start_path = val

var current_path:String:
	set(val):
		current_path = val
		
		if !file_picker:
			return
		
		_update_texture()
		
		file_picker.current_path = val


func _ready() -> void:
	pass

func _update_texture():
	if !texture_rext:
		return
	
	if !ResourceLoader.exists(current_path):
		return
	
	texture_rext.texture = load(current_path)

func _on_file_picker_path_changed(path: String) -> void:
	current_path = path
	_update_texture()
	path_changed.emit(path)

func _on_file_picker_path_selected(path: String) -> void:
	path_selected.emit(path)
