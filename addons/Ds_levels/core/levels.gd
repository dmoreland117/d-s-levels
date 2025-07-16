class_name Levels


static var level_container:Node
static var loader:LevelLoader
static var storage:LevelDataStorage


static func load_level_in_background():
	pass

static func change_to_level(level:LevelData, spawn:String, args:Dictionary):
	loader.load_from_data(level, spawn)

static func get_levels() -> Array[LevelData]:
	if !storage:
		return []
	
	return storage.get_data_list()

static func get_level_storage() -> LevelDataStorage:
	if !storage:
		return
	
	return storage

static func _set_level_container(container:Node):
	level_container = container
	loader = LevelLoader.new()
	loader.loaded.connect(_on_level_loaded)
	container.add_child(loader)
	storage = LevelDataStorage.load_from_settings_path()

static func _on_level_loaded(label:String, level:Node):
	level_container.set_level(level)
