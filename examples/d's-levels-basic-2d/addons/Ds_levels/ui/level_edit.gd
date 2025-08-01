@tool
extends HSplitContainer


@onready var level_data_list: VBoxContainer = %level_data_list
@onready var level_data_inspector: VBoxContainer = %level_data_inspector


func _on_level_data_list_edit_pressed(index: int) -> void:
	level_data_inspector.set_index(index)

func _on_level_data_inspector_saved() -> void:
	level_data_list._populate_levels_list()
