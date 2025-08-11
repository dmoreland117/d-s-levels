class_name LevelMenu
extends CanvasLayer


signal level_start(args:LevelChangeData)

var level_change_data:LevelChangeData


func _ready() -> void:
	if !level_change_data:
		printerr('Level_change_args is null')
		return
	
	LevelNodeUtils.send_dbg_change_data(level_change_data)
	level_start.emit(level_change_data)

## Returns the [LevelChangeData] for the Level
func get_level_change_data() -> LevelChangeData:
	if !level_change_data:
		return
	
	return level_change_data

func get_level_data():
	if !level_change_data:
		return
	
	return level_change_data.level_data
