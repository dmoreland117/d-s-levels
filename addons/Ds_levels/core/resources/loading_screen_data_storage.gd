@tool
class_name LoadingScreenDataStorage
extends Resource


static var loading_screen_datas:Array[Dictionary] = []
static var is_loaded:bool = false

static func add_data(label:String, path:String) -> bool:
	
	loading_screen_datas.append(
		{
			'label': label,
			'path': path
		}
	)
	
	save_at_settings_path()
	return true
	
static func edit_data(index:int, data:Dictionary) -> bool:
	if !loading_screen_datas:
		return false
	
	if !index <= loading_screen_datas.size():
		return false
	
	loading_screen_datas[index] = data
	
	save_at_settings_path()
	return true
	
static func remove_data(index:int) -> bool:
	if !loading_screen_datas:
		return false
	
	if !index <= loading_screen_datas.size():
		return false
	
	loading_screen_datas.remove_at(index)
	
	save_at_settings_path()
	return true
	
static func get_data_list() -> Array[Dictionary]:
	if !loading_screen_datas:
		return []
	
	return loading_screen_datas
	
static func get_data_by_label(label:String) -> Dictionary:
	if !loading_screen_datas:
		return {}
	
	for screen in loading_screen_datas:
		if screen.get('label') == label:
			return screen
	
	return {}
	
static func get_data_by_index(index:int) -> Dictionary:
	if !loading_screen_datas:
		return {}
	
	if !index <= loading_screen_datas.size():
		return {}
	
	return loading_screen_datas[index]

static func get_index_by_label(label:String) -> int:
	if !loading_screen_datas:
		return -1
	
	var i = 0
	for data in loading_screen_datas:
		if data.get('label', '') == label:
			return i
		
		i += 1
	
	return -1

static func has_data(label:String) -> bool:
	if !loading_screen_datas:
		return false
	
	for screen in loading_screen_datas:
		if screen.get('label') == label:
			return true
	
	return false
	
static func save_at_settings_path() -> bool:
	var datas = []
	for data in loading_screen_datas:
		datas.append(data)
	
	var dict = {
		'datas': datas,
	}
	
	var file = FileAccess.open(LevelManagerPlugin.get_loading_screen_storage_path(), FileAccess.WRITE)
	var dict_string = str(dict)
	file.store_string(dict_string)
	file.close()
	return true

static func load_from_settings_path() -> bool:
	if is_loaded:
		return true
		
	var path = LevelManagerPlugin.get_loading_screen_storage_path()
	if !FileAccess.file_exists(path):
		return false
		
	var dict_string = FileAccess.get_file_as_string(LevelManagerPlugin.get_loading_screen_storage_path())
	if dict_string.is_empty():
		print('dict is empty')
		save_at_settings_path()
	
	var dict:Dictionary = JSON.parse_string(dict_string)
	if !dict:
		print('failed parsing json')
		return false
	
	var datas = dict.get('datas', [])
	for data in datas:
		add_data(
			data.get('label', '[Error]'),
			data.get('path', '[Error]')
		)
	
	is_loaded = true
	return true

static func is_storage_loaded() -> bool:
	return is_loaded
