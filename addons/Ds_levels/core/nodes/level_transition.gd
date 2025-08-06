class_name LevelTransition
extends Control


signal transition_done()
signal show_next_level()

var speed_scale:float


func _ready() -> void:
	pass

func transition_finished():
	transition_done.emit()

func transition_in() -> LevelTransition:
	_transition_in()
	
	return self

func transition_out() -> LevelTransition:
	_transition_out()
	
	return self

func load_next_level():
	show_next_level.emit()

func _transition_in():
	pass

func _transition_out():
	pass
