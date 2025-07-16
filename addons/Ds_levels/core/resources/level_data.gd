class_name LevelData
extends Resource

@export var label:String = ''
@export var description:String = ''
@export_file('*.tscn') var level_path = ''
@export_file() var loading_screen_background_path:String = ''
@export var loading_screen_name:String = ''
@export var show_loading_screen:bool = false
