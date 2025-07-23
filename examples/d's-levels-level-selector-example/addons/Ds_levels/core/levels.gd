class_name Levels
## A static class that can change and unload [Levels]


static var loading_screen_container:CanvasLayer
static var loading_screen:LoadingScreen

static var level_container:Node
static var current_level:Node

static var loader:LevelLoader


static func load_level_in_background():
	pass

## Unloads the current level and loads the start level set in the Levels tab
## at [spawn] with [args].
static func change_to_start_level(spawn:String, args:Dictionary):
	if !LevelDataStorage.is_storage_loaded():
		return
	
	var data = LevelDataStorage.get_start_level()
	change_to_level(data, spawn, args)

## Unloads any current levels and changes to the provided [level] at [spawn] with [args].
static func change_to_level(level:LevelData, spawn:String, args:Dictionary):
	loader.load_from_data(level, spawn)
	if level.show_loading_screen:
		_show_loading_screen(level)

## Unloads any current levels and changes to the provided [label] at [spawn] with [args].
static func change_to_level_name(label:String, spawn:String, args:Dictionary = {}):
	var data = LevelDataStorage.get_data_by_label(label)
	if !data:
		return
	
	change_to_level(data, spawn, args)

## Returns a list of [LevelData]s
static func get_levels(include_hidden:bool = false) -> Array[LevelData]:
	if !LevelDataStorage.is_storage_loaded():
		return []
	
	return LevelDataStorage.get_data_list(include_hidden)

## Returns the currently loaded [Level]
static func get_current_level() -> Node:
	if !current_level:
		return
	
	return current_level

## Returns the [LevelLoader] Node
static func get_loader() -> LevelLoader:
	if !loader:
		return
	
	return loader

static func _set_level_container(container:Node):
	loader = LevelLoader.new()
	loader.loaded.connect(_on_level_loaded)
	
	level_container = container
	container.add_child(loader)
	_add_loading_screen_container()
	
	LevelDataStorage.load_from_settings_path()
	LoadingScreenDataStorage.load_from_settings_path()

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
	
	var loading_screen_path = LoadingScreenDataStorage.get_data_by_label(data.loading_screen_name).get('path')
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
