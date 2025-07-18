@tool
extends MarginContainer


const LEVEL_EDIT_INDEX = 0
const LOADING_SCREEN_EDIT_INDEX = 1



@onready var loading_screen_edit: VBoxContainer = %loading_screen_edit
@onready var level_edit = %level_edit



func _on_tab_bar_tab_changed(tab: int) -> void:
	match tab:
		LEVEL_EDIT_INDEX:
			loading_screen_edit.hide()
			level_edit.show()
		
		LOADING_SCREEN_EDIT_INDEX:
			loading_screen_edit.show()
			level_edit.hide()
