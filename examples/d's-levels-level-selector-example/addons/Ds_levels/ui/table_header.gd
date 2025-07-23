@tool
extends PanelContainer

@onready var h_box_container: HBoxContainer = $HBoxContainer/HBoxContainer2
@onready var spacer: Control = $HBoxContainer/spacer

@export var columns:Array[String] : set = _refresh_columns
@export var trailing_space:int = 0 :
	set(val):
		trailing_space = val
		if !spacer:
			return
		
		spacer.custom_minimum_size.x = trailing_space


func _ready() -> void:
	if !h_box_container:
		printerr('hboxcontainer is null')
		return
	
	spacer.custom_minimum_size.x = trailing_space
	
	_refresh_columns(columns)

func _refresh_columns(cols:Array[String]):
	columns = cols
	if !h_box_container:
		return
	
	
	for child in h_box_container.get_children():
		if child.name == 'spacer':
			continue
		
		child.queue_free()
	
	for column in cols:
		_add_label(column)

func _add_label(label:String):
	var l = Label.new()
	l.text = label
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_box_container.add_child(l)
