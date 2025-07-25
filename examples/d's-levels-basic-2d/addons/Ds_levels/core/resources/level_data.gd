class_name LevelData
extends Resource


@export_file('*.tscn') var preview_path:String = ''
@export var label:String = ''
@export var description:String = ''
@export_file('*.tscn') var level_path = ''
@export_file() var loading_screen_background_path:String = ''
@export var loading_screen_name:String = ''
@export var show_loading_screen:bool = false
@export var hidden:bool = false
@export var transition_in_index:int = -1
@export var transition_out_index:int = -1


func to_dict():
	var ret = {
		'label': label,
		'description': description,
		'level_path': level_path,
		'hidden': hidden,
		'loading_screen_background_path': loading_screen_background_path,
		'loading_screen_name': loading_screen_name,
		'show_loading_screen' : show_loading_screen,
		'trans_in': transition_in_index,
		'trans_out': transition_out_index,
		'preview_path': preview_path
	}
	return ret

static func from_dict(dict:Dictionary) ->LevelData:
	var data = LevelData.new()
	
	data.label = dict.get('label')
	data.description = dict.get('description')
	data.level_path = dict.get('level_path')
	data.hidden = dict.get('hidden', false)
	data.loading_screen_background_path = dict.get('loading_screen_background_path')
	data.loading_screen_name = dict.get('loading_screen_name')
	data.show_loading_screen = dict.get('show_loading_screen', false)
	data.transition_in_index = dict.get('trans_in', -1)
	data.transition_out_index = dict.get('trans_out', -1)
	data.preview_path =  dict.get('preview_path', '')
	
	return data
