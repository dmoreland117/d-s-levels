@tool
class_name PluginUI
extends VBoxContainer


signal reload_level_pressed()
signal go_to_start_level_pressed()

@onready var reload_button: Button = %reload_button
@onready var start_level_button: Button = %start_level_button
@onready var loaded_level_section: VBoxContainer = %loaded_level_section

var loaded_level_inspector:EditorInspector


func _ready() -> void:
	loaded_level_inspector = EditorInspector.new()
	loaded_level_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	loaded_level_inspector.edit(LevelData.new())
	loaded_level_section.add_child(loaded_level_inspector)

func set_current_level(label:String):
	var data = LevelDataStorage.get_data_by_label(label)
	loaded_level_inspector.edit(data)

func _on_reload_button_pressed() -> void:
	reload_level_pressed.emit()

func _on_start_level_button_pressed() -> void:
	go_to_start_level_pressed.emit()
