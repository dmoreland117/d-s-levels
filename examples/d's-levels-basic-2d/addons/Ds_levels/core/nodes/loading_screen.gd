@tool
class_name LoadingScreen
extends Control


signal progress_updated(progress:int)

var background:Texture
var level_data:LevelData


func _ready() -> void:
	if background:
		_set_up_background(background)
	
	if level_data:
		_set_up_labels(level_data)

func update_progress(progress:int):
	_progress_updated(progress)
	progress_updated.emit(progress)

func _set_up_background(bkg:Texture):
	pass

func _set_up_labels(data:LevelData):
	pass

func _progress_updated(progress:int):
	pass

func _process(delta: float) -> void:
	if !level_data or Engine.is_editor_hint():
		return
	
	var loader = Levels.get_loader()
	var prog = Levels.get_loader().get_load_progress(level_data.label)
	if prog:
		progress_updated.emit(prog)
		_progress_updated(prog)
	
