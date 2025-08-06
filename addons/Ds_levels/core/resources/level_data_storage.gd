@tool
class_name LevelDataStorage
extends Resource


static var level_datas:Array[LevelData] = []

static var player_scene_path:String = ''
static var start_level_index:int = 0
static var is_loaded:bool = false

## Adds the [LevelData] to the [LevelDataStorage] and saves it to the json path.
static func add_data(data:LevelData) -> bool:
	if !level_datas:
		level_datas = []
	
	level_datas.append(data)
	save_at_settings_path()
	return true

## Edits a [LevelData] in storage and saves.
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

## Sets the default level index to start if a [LevelContainer] has been added.
static func set_start_level(index:int):
	start_level_index = index
	save_at_settings_path()

## Returns the [LevelData] for the start level.
static func get_start_level() -> LevelData:
	return get_data_by_index(start_level_index)

## Returns a list of all [LevelData]s in storage excluding hidden if include_hidden not set..
static func get_data_list(include_hidden:bool = false) -> Array[LevelData]:
	if !level_datas:
		return []
	
	var ret:Array[LevelData] = []
	for data in level_datas:
		if !include_hidden and data.hidden:
			continue
		
		ret.append(data)
	
	return ret

static func get_data_by_label(label:String) -> LevelData:
	for data in level_datas:
		if data.label == label:
			return data
	
	return

static func get_data_by_path(path:String) -> LevelData:
	for data in level_datas:
		if data.level_path == path:
			return data
	
	return

static func get_data_by_index(index:int) -> LevelData:
	if !level_datas:
		return
	
	if !index <= level_datas.size():
		return
	
	return level_datas[index]

static func get_index_by_label(label):
	var i = 0
	for data in level_datas:
		if data.label == label:
			return i
		
		i += 1
	
	return 0

static func has_data(label:String) -> bool:
	if !level_datas:
		return false
	
	for data in level_datas:
		if data.label == label:
			return true
	
	return false

## Returns the default player scene path.
static func get_player_scene_path() -> String:
	if !player_scene_path:
		return ''
	
	return player_scene_path

static func set_player_scene_path(path:String):
	player_scene_path = path

## Returns if the [LevelData] is the start level.
static func is_start_level(data:LevelData):
	var start_data = get_data_by_index(start_level_index)
	if !start_data:
		return false
	
	if start_data.label == data.label:
		return true

## Saves the storage to JSON.
static func save_at_settings_path() -> bool:
	var datas = []
	for data in level_datas:
		datas.append(data.to_dict())
	
	var dict = {
		'datas': datas,
		'player_path': player_scene_path,
		'start_index': start_level_index
	}
	
	return StorageUtils.save_dict_to_file(dict, LevelManagerPlugin.get_levels_storage_path())
		
## Soads storage from JSON.
static func load_from_settings_path() -> bool:
	if is_loaded:
		return true
		
	var path = LevelManagerPlugin.get_levels_storage_path()
	
	var dict:Dictionary = StorageUtils.load_dict_from_path(path)
	if dict.is_empty():
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
