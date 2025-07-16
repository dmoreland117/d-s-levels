@tool
class_name LevelDataStorage
extends Resource


signal data_updated()

@export var level_datas:Array[LevelData] = [] :
	set(val):
		level_datas = val

		data_updated.emit()


func add_data(data:LevelData) -> bool:
	if !level_datas:
		return false
	
	level_datas.append(data)
	save_at_settings_path()
	data_updated.emit()
	return true
	


func edit_data(index:int, data:LevelData) -> bool:
	if !level_datas:
		return false
	
	if !index <= level_datas.size():
		return false
	
	level_datas[index] = data
	save_at_settings_path()
	
	data_updated.emit()
	
	return true

func remove_data(index:int) -> bool:
	if !level_datas:
		return false
	
	if !index <= level_datas.size():
		return false
	
	level_datas.remove_at(index)
	save_at_settings_path()

	data_updated.emit()
	return true

func get_data_list() -> Array[LevelData]:
	if !level_datas:
		return []
		
	return level_datas

func get_data_by_label(label:String) -> LevelData:
	return

func get_data_by_index(index:int) -> LevelData:
	if !level_datas:
		return
	
	if !index <= level_datas.size():
		return
	
	return level_datas[index]
	
func has_data(label:String) -> bool:
	if !level_datas:
		return false
	
	for data in level_datas:
		if data.label == label:
			return true
	
	return false
	
func save_at_settings_path() -> bool:
	var storage_path = LevelManagerPlugin.get_levels_storage_path()
	if !storage_path.is_valid_filename():
		return false

	ResourceSaver.save(self, storage_path)
	return true

static func load_from_settings_path() -> LevelDataStorage:
	var storage_path = LevelManagerPlugin.get_levels_storage_path()

	if !ResourceLoader.exists(storage_path):
		return
	
	var new_storage = load(storage_path)

	return new_storage
