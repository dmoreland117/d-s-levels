class_name LevelTransition
extends Control


enum {
	TRANSITION_MODE_IN,
	TRANSITION_MODE_OUT
}

signal transition_done()
signal ok_show_next_level()

var mode = 0


func _ready() -> void:
	if mode == TRANSITION_MODE_IN: _transition_in()
	if mode == TRANSITION_MODE_OUT: _transition_out()

func transition_finished():
	transition_done.emit()

func show_next_level():
	ok_show_next_level.emit()

func _transition_in():
	pass

func _transition_out():
	pass
