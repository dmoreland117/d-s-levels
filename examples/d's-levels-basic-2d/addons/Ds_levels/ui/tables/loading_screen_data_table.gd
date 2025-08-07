@tool
extends VBoxContainer


const LOADING_SCREEN_TABLE_ITEM = preload("res://addons/Ds_levels/ui/tables/loading_screen_table_item.tscn")

signal row_edited(index:int, data:Dictionary)
signal remove_pressed(index:int)

@onready var item_list: VBoxContainer = %item_list


func clear_table():
	for child in item_list.get_children():
		item_list.remove_child(child)
		child.queue_free()

func add_row(data:Dictionary):
	var instance = LOADING_SCREEN_TABLE_ITEM.instantiate()
	
	instance.screen_data = data
	instance.data_changed.connect(
		func(index, data):
			row_edited.emit(index, data)
	)
	instance.remove_pressed.connect(
		func(index:int):
			remove_pressed.emit(index)
	)
	
	item_list.add_child(instance)
