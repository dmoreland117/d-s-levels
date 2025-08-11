@tool
class_name PluginUI
extends VBoxContainer


signal reload_level_pressed()
signal go_to_start_level_pressed()

@onready var reload_button: Button = %reload_button
@onready var start_level_button: Button = %start_level_button
@onready var loaded_level_section: VBoxContainer = %loaded_level_section
@onready var level_name_label: Label = %level_name_label
@onready var level_progress_label: Label = %level_progress_label
@onready var level_change_data_section_2: VBoxContainer = %level_change_data_section2

var loaded_level_inspector:EditorInspector
var level_change_data_inspector:EditorInspector


func _ready() -> void:
	loaded_level_inspector = EditorInspector.new()
	loaded_level_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	loaded_level_inspector.edit(LevelData.new())
	loaded_level_section.add_child(loaded_level_inspector)
	
	level_change_data_inspector = EditorInspector.new()
	level_change_data_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	level_change_data_inspector.edit(LevelChangeData.new())
	level_change_data_section_2.add_child(loaded_level_inspector)

func set_loading_level_name(label:String):
	level_name_label.text = label

func set_load_progress(progress:int):
	level_progress_label.text = str(progress)

func set_current_level(label:String):
	var data = LevelDataStorage.get_data_by_label(label)
	loaded_level_inspector.edit(data)

func _on_reload_button_pressed() -> void:
	reload_level_pressed.emit()

func set_change_data(spawn_point:String, args:Dictionary):
	var l = Label.new()
	l.text = str(args)
	level_change_data_section_2.add_child(l)
	
func _on_start_level_button_pressed() -> void:
	go_to_start_level_pressed.emit()
