class_name StorageUtils


static func save_dict_to_file(dict:Dictionary, path:String) -> bool:
	if path.is_empty():
		return false
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if !file:
		return false
	
	var dict_string = str(dict)
	file.store_string(dict_string)
	file.close()
	return true

static func load_dict_from_path(path) -> Dictionary:
	if !FileAccess.file_exists(path):
		return {}
			
	var dict_string = FileAccess.get_file_as_string(path)
	if dict_string.is_empty():
		return {}
	
	return JSON.parse_string(dict_string)

static func get_array_index_of_dict_by_key_value(array:Array, key:String, value) -> int:
	var i = 0
	for item in array:
		if item is not Dictionary:
			return 0
		
		var val = item.get(key)
		if value:
			if value == val:
				return i
		
		i += 1
	
	return 0

static func get_array_dict_item_by_key_value(array:Array, key, value):
	for item in array:
		if item is not Dictionary:
			return
		
		var val = item.get(key)
		if !val:
			return
		
		if val == value:
			return item 
