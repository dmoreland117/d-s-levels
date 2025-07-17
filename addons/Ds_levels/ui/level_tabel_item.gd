@tool
extends Control

signal edit_pressed(index:int)
signal open_pressed(index:int)
signal remove_pressed(index:int)

@onready var level_name_label: Label = %level_name_label
@onready var level_path_label: Label = %level_path_label
@onready var edit_button: Button = %edit_button
@onready var open_button: Button = %open_button
@onready var level_description_label: Label = %level_description_label
@onready var remove_button: Button = %remove_button

var label:String = ''
var path:String = ''
var description:String = ''


func _ready() -> void:
	level_name_label.text = label
	level_path_label.text = path
	level_description_label.text = description
	
	var theme = EditorInterface.get_editor_theme()
	edit_button.icon = theme.get_icon('Edit', 'EditorIcons')
	open_button.icon = theme.get_icon('PackedScene', 'EditorIcons')
	remove_button.icon = theme.get_icon('Remove', 'EditorIcons')

func _on_edit_button_pressed() -> void:
	edit_pressed.emit(get_index())

func _on_open_button_pressed() -> void:
		open_pressed.emit(get_index())

func _on_remove_button_pressed() -> void:
	remove_pressed.emit(get_index())
