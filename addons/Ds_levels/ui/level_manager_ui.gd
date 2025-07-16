@tool
extends MarginContainer


@onready var level_data_inspector: VBoxContainer = %level_data_inspector


func _on_level_data_list_edit_pressed(index: int) -> void:
	level_data_inspector.set_index(index)
