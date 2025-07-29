extends Control


@onready var default_transition: LevelTransition = %default_transition


func _on_trans_in_button_pressed() -> void:
	default_transition.transition_in()


func _on_trans_out_button_pressed() -> void:
	default_transition.transition_out()
