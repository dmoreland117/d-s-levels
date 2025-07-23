@tool
extends VBoxContainer


const LEVEL_TABEL_ITEM = preload("res://addons/Ds_levels/ui/level_tabel_item.tscn")

signal edit_pressed(index:int)
signal open_pressed(index:int)
signal remove_pressed(index:int)

@onready var item_list: VBoxContainer = %item_list
@onready var no_items_texture: TextureRect = %no_items_texture
@onready var no_items: VBoxContainer = %no_items
@onready var scroll_container: ScrollContainer = $ScrollContainer

func add_row(label:String, description:String, path:String) -> Control:
	var instance = LEVEL_TABEL_ITEM.instantiate()
	instance.label = label
	instance.path = path
	instance.description = description
	
	instance.edit_pressed.connect(
		func(index):
			edit_pressed.emit(index)
	)
	instance.open_pressed.connect(
		func(index):
			open_pressed.emit(index)
	)
	instance.remove_pressed.connect(
		func(index):
			remove_pressed.emit(index)
	)
	
	item_list.add_child(instance)
	
	if item_list.get_child_count() == 0:
		scroll_container.hide()
		no_items.show()
		return
	
	scroll_container.show()
	no_items.hide()
	
	return instance


func _ready() -> void:
	_add_icons()
	
	if item_list.get_child_count() == 0:
		scroll_container.hide()
		no_items.show()
		return
	
	scroll_container.show()
	no_items.hide()

func clear_table():
	for child in item_list.get_children():
		child.queue_free()
	
	if item_list.get_child_count() == 0:
		scroll_container.hide()
		no_items.show()
		return
	
	scroll_container.show()
	no_items.hide()

func _add_icons():
	if !Engine.is_editor_hint():
		return 
		
	var t = EditorInterface.get_editor_theme()
	var tex = t.get_icon('Add', "EditorIcons")
	no_items_texture.texture = tex
	
