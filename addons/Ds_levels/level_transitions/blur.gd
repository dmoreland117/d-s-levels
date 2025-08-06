extends LevelTransition


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _transition_in():
	animation_player.play("anim_in")

func _transition_out():
	animation_player.play("anim_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	transition_finished()
