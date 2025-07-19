class_name LevelData
extends Resource

@export var label:String = ''
@export var description:String = ''
@export_file('*.tscn') var level_path = ''
@export_file() var loading_screen_background_path:String = ''
@export var loading_screen_name:String = ''
@export var show_loading_screen:bool = false


func to_dict():
	var ret = {
		'label': label,
		'description': description,
		'level_path': level_path,
		'loading_screen_background_path': loading_screen_background_path,
		'loading_screen_name': loading_screen_name,
		'show_loading_screen' : show_loading_screen
	}
	print(ret)
	return ret

static func from_dict(dict:Dictionary) ->LevelData:
	var data = LevelData.new()
	
	data.label = dict.get('label')
	data.description = dict.get('description')
	data.level_path = dict.get('level_path')
	data.loading_screen_background_path = dict.get('loading_screen_background_path')
	data.loading_screen_name = dict.get('loading_screen_name')
	data.show_loading_screen = dict.get('show_loading_screen')
	
	return data
