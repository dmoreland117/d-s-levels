extends LoadingScreen


@onready var level_name_label: Label = %level_name_label
@onready var level_description_label: Label = %level_description_label
@onready var level_path_label: Label = %level_path_label
@onready var progress_bar: ProgressBar = %ProgressBar


func _set_up_background(bkg_texture):
	pass

func _set_up_labels(data:LevelData):
	level_name_label.text = data.label
	level_description_label.text = data.description
	level_path_label.text = data.level_path

func _on_progress_updated(progress: int) -> void:
	if !progress_bar:
		return
	
	progress_bar.value = progress
	print(progress)
