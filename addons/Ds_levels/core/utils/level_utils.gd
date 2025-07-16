class_name LevelLoader


signal loaded(label:String)

var loading_progress:Array[Dictionary]
var storage:LevelDataStorage


func _ready():
	pass

func load_from_path(path:String, spawn:String, data = null):
	pass

func load_from_data(data:LevelData, spawn:String):
	pass

func load_level_by_label(label:String, spawn:String):
	pass

func _set_level_change_data(level, data:LevelData, spawn:String):
	pass
