@tool
extends LoadingScreen


const LEVEL_INFO_TEXT = '%s - %s'

@onready var bkg: TextureRect = %bkg
@onready var level_name_description_label: Label = %level_name_description_label
@onready var progress_bar: ProgressBar = %ProgressBar


func _set_up_background(bkg_texture):
	if !bkg:
		return
	
	bkg.texture = bkg_texture

func _set_up_labels(data:LevelData):
	if !level_name_description_label:
		return
	
	level_name_description_label.text = LEVEL_INFO_TEXT % [data.label, data.description]

func _on_progress_updated(progress: int) -> void:
	if !progress_bar:
		return
	
	progress_bar.value = progress
