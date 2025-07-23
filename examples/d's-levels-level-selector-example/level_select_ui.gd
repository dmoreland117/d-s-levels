extends PanelContainer


const LEVEL_LIST_ITEM = preload("res://level_list_item.tscn")

@onready var levels_list: VBoxContainer = %levels_list

var levels:Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels = Levels.get_levels()
	_gen_items_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _gen_items_list():
	for child in levels_list.get_children():
		child.queue_free()
	
	for level in levels:
		var item_instance = LEVEL_LIST_ITEM.instantiate()
		item_instance.play_pressed.connect(_play_pressed)
		item_instance.data = level
		levels_list.add_child(item_instance)
		
func _play_pressed(data:LevelData):
	Levels.change_to_level(data, ' ', {})
