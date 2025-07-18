class_name Levels


static var loading_screen_container:CanvasLayer
static var loading_screen:LoadingScreen

static var level_container:Node
static var current_level:Node

static var loader:LevelLoader

static var storage:LevelDataStorage
static var loading_screen_storage:LoadingScreenDataStorage


static func load_level_in_background():
	pass

static func change_to_level(level:LevelData, spawn:String, args:Dictionary):
	loader.load_from_data(level, spawn)
	if level.show_loading_screen:
		_show_loading_screen(level)

static func change_to_start_level():
	pass

static func get_levels() -> Array[LevelData]:
	if !storage:
		return []
	
	return storage.get_data_list()

static func get_current_level() -> Node:
	if !current_level:
		return
	
	return current_level
	
static func get_level_storage() -> LevelDataStorage:
	if !storage:
		return
	
	return storage

static func get_loader() -> LevelLoader:
	if !loader:
		return loader
	
	return

static func _set_level_container(container:Node):
	loader = LevelLoader.new()
	loader.loaded.connect(_on_level_loaded)
	
	level_container = container
	container.add_child(loader)
	_add_loading_screen_container()
	
	storage = LevelDataStorage.load_from_settings_path()
	loading_screen_storage = LoadingScreenDataStorage.load_from_settings_path()

static func _on_level_loaded(label:String, level:Node):
	level_container.set_level(level)
	current_level = level
	_hide_loading_screen()

static func _add_loading_screen_container():
	if !level_container:
		return
	
	loading_screen_container = CanvasLayer.new()
	level_container.add_child(loading_screen_container)

static func _show_loading_screen(data:LevelData):
	if !loading_screen_container or !level_container:
		return
	
	var loading_screen_path = loading_screen_storage.get_data_by_label(data.loading_screen_name).get('path')
	if !loading_screen_path:
		return
	
	
	loading_screen = LoadingScreenUtils.load_from_path(loading_screen_path, data)
	loading_screen_container.add_child(loading_screen)

static func _hide_loading_screen():
	if !loading_screen_container:
		return
	
	if !loading_screen:
		return
	
	loading_screen_container.remove_child(loading_screen)
	loading_screen.queue_free()
