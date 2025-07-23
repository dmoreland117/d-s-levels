@tool
extends Panel


func _ready():
	var t = EditorInterface.get_editor_theme()
	var style = t.get_stylebox('EditorStyles', 'Background').duplicate()
	
	add_theme_stylebox_override("panel", style)
	
