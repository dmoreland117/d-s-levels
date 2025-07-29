class_name StorageUtils


static func save_dict_to_file(dict:Dictionary, path:String) -> bool:
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
		