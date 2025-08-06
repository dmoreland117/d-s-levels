class_name TransitionDataStorage
extends Resource


static var transition_infos:Array = []
static var _is_loaded:bool = false


static func add_data(label:String, path:String):
	var new_data = {
		'label': label,
		'path': path
	}
	
	transition_infos.append(new_data)

static func remove_data(index:int):
	transition_infos.remove_at(index)

static func edit_data(index:int, data:Dictionary):
	transition_infos[index] = data

static func get_index_by_label(label:String):
	return StorageUtils.get_array_index_of_dict_by_key_value(
		transition_infos, 
		'label', 
		label
	)

static func get_data_list() -> Array:
	return transition_infos

static func get_data(index):
	return transition_infos[index]

static func save_at_settings_path() -> bool:
	var data = {
		'data': transition_infos
	}
	
	return StorageUtils.save_dict_to_file(data, LevelManagerPlugin.get_transition_storage_path())

static func load_from_settings_path() -> bool:
	if _is_loaded:
		return true
	
	var dict = StorageUtils.load_dict_from_path(LevelManagerPlugin.get_transition_storage_path())
	if dict.is_empty():
		return false
	
	transition_infos = dict.get('data', {})
	
	_is_loaded = true
	return true
