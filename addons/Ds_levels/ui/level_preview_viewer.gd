@tool
extends VBoxContainer

@onready var preview: TextureRect = %preview
@onready var fullscreen_button: Button = %fullscreen_button

@export_file() var path:String = '':
	set(val):
		path = val
		
		if !preview:
			return
		
		preview.texture = _load_image()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preview.texture = _load_image()
	
	var t = EditorInterface.get_editor_theme()
	fullscreen_button.icon = t.get_icon('DistractionFree', 'EditorIcons')

func _load_image() -> Texture:
	if !ResourceLoader.exists(path) or path.is_empty():
		if fullscreen_button:
			fullscreen_button.disabled = true
		
		return load('res://addons/Ds_levels/icon.svg')
		
	
	fullscreen_button.disabled = false
	var tex = load(path)
	
	return tex
