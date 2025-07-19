@tool
class_name LevelDataStorage
extends Resource


static var level_datas:Array[LevelData] = []

static var player_scene_path:String = ''
static var start_level_index:int = 0
static var is_loaded:bool = false


static func add_data(data:LevelData) -> bool:
	if !level_datas:
		level_datas = []
	
	level_datas.append(data)
	save_at_settings_path()
	return true
	
static func edit_data(index:int, data:LevelData) -> bool:
	if !level_datas:
		return false
	
	if !index <= level_datas.size():
		return false
	
	level_datas[index] = data
	save_at_settings_path()
	
	return true

static func remove_data(index:int) -> bool:
	if !level_datas:
		return false
	
	if !index <= level_datas.size():
		return false
	
	level_datas.remove_at(index)
	save_at_settings_path()

	return true

static func set_start_level(index:int):
	start_level_index = index
	save_at_settings_path()

static func get_start_level() -> LevelData:
	return get_data_by_index(start_level_index)

static func get_data_list() -> Array[LevelData]:
	if !level_datas:
		return []
		
	return level_datas

static func get_data_by_label(label:String) -> LevelData:
	for data in level_datas:
		if data.label == label:
			return data
	
	return

static func get_data_by_index(index:int) -> LevelData:
	if !level_datas:
		return
	
	if !index <= level_datas.size():
		return
	
	return level_datas[index]
	
static func has_data(label:String) -> bool:
	if !level_datas:
		return false
	
	for data in level_datas:
		if data.label == label:
			return true
	
	return false

static func get_player_scene_path() -> String:
	if !player_scene_path:
		return ''
	
	return player_scene_path

static func set_player_scene_path(path:String):
	player_scene_path = path

static func is_start_level(data:LevelData):
	var start_data = get_data_by_index(start_level_index)
	if !start_data:
		return false
	
	if start_data.label == data.label:
		return true

static func save_at_settings_path() -> bool:
	var datas = []
	for data in level_datas:
		datas.append(data.to_dict())
	
	if datas.is_empty():
		datas = []
	
	var dict = {
		'datas': datas,
		'player_path': player_scene_path,
		'start_index': start_level_index
	}
	
	print(dict)
	
	var file = FileAccess.open(LevelManagerPlugin.get_levels_storage_path(), FileAccess.WRITE)
	var dict_string = str(dict)
	file.store_string(dict_string)
	file.close()
	return true

static func load_from_settings_path() -> bool:
	if is_loaded:
		return true
		
	var path = LevelManagerPlugin.get_levels_storage_path()
	if !FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.WRITE)
		if !file:
			return false
		
		save_at_settings_path()
	
	var dict_string = FileAccess.get_file_as_string(LevelManagerPlugin.get_levels_storage_path())
	if dict_string.is_empty():
		return false
	
	var dict:Dictionary = JSON.parse_string(dict_string)
	print(dict)
	if !dict:
		print('failed parsing json')
		return false
	
	
	player_scene_path = dict.get('player_path')
	start_level_index = dict.get('start_index')
	
	var datas = dict.get('datas', [])
	for data in datas:
		add_data(LevelData.from_dict(data))
	
	is_loaded = true
	return true

static func is_storage_loaded() -> bool:
	return is_loaded
