extends LevelTransition


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _transition_in():
	animation_player.play("anim")
	show_next_level()

func _transition_out():
	animation_player.play_backwards("anim")
	show_next_level()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if !anim_name == 'anim':
		return
	transition_finished()
