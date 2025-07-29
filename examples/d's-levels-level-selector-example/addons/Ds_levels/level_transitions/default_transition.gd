extends LevelTransition


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _transition_in():
	animation_player.play("anim")

func _transition_out():
	animation_player.play_backwards("anim")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if !anim_name == 'anim':
		return
	transition_finished()
