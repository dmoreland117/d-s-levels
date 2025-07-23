extends HBoxContainer


signal play_pressed(data:LevelData)

@onready var label: Label = %Label
@onready var button: Button = %Button

var data:LevelData


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = data.label
	button.pressed.connect(_on_button_pressed.bind(data))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed(data:LevelData) -> void:
	play_pressed.emit(data)
