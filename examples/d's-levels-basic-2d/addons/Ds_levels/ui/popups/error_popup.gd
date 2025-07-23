@tool
extends VBoxContainer


var error_text:String = ''
@onready var label: Label = $Label


func _ready() -> void:
	label.text = error_text


func _on_button_pressed() -> void:
	get_parent().queue_free()
