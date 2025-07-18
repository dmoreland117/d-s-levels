@tool
class_name LoadingScreenDataStorage
extends Resource


signal data_updated()

@export var loading_screen_datas:Array[Dictionary] = []:
	set(val):
		loading_screen_datas = val

		data_updated.emit()


func add_data(label:String, path:String) -> bool:
	
	loading_screen_datas.append(
		{
			'label': label,
			'path': path
		}
	)
	
	save_at_settings_path()
	data_updated.emit()
	return true
	
func edit_data(index:int, data:Dictionary) -> bool:
	if !loading_screen_datas:
		return false
	
	if !index <= loading_screen_datas.size():
		return false
	
	loading_screen_datas[index] = data
	
	save_at_settings_path()
	data_updated.emit()
	return true
	
func remove_data(index:int) -> bool:
	if !loading_screen_datas:
		return false
	
	if !index <= loading_screen_datas.size():
		return false
	
	loading_screen_datas.remove_at(index)
	
	save_at_settings_path()
	data_updated.emit()
	return true
	
func get_data_list() -> Array[Dictionary]:
	if !loading_screen_datas:
		return []
	
	return loading_screen_datas
	
func get_data_by_label(label:String) -> Dictionary:
	if !loading_screen_datas:
		return {}
	
	for screen in loading_screen_datas:
		if screen.get('label') == label:
			return screen
	
	return {}
	
func get_data_by_index(index:int) -> Dictionary:
	if !loading_screen_datas:
		return {}
	
	if !index <= loading_screen_datas.size():
		return {}
	
	return loading_screen_datas[index]

func get_index_by_label(label:String) -> int:
	if !loading_screen_datas:
		return -1
	
	var i = 0
	for data in loading_screen_datas:
		if data.get('label', '') == label:
			return i
		
		i += 1
	
	return -1

func has_data(label:String) -> bool:
	if !loading_screen_datas:
		return false
	
	for screen in loading_screen_datas:
		if screen.get('label') == label:
			return true
	
	return false
	
func save_at_settings_path() -> bool:
	var storage_path = LevelManagerPlugin.get_loading_screen_storage_path()

	var err = ResourceSaver.save(self, storage_path)
	if err != OK:
		printerr('Failed loading resource at path: %s code:%d ' % [storage_path, err])
		return false
		
	return true
	
static func load_from_settings_path() -> LoadingScreenDataStorage:
	var storage_path = LevelManagerPlugin.get_loading_screen_storage_path()

	if !ResourceLoader.exists(storage_path):
		return
	
	var new_storage = load(storage_path)

	return new_storage
