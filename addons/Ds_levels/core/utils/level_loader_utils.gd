class_name LevelLoader
extends Node


signal loaded(label:String, level:Node)
signal failed_load(label:String)

var loading_levels:Dictionary = {}
var level_datas:Dictionary = {}
var level_spawns:Dictionary = {}

var storage:LevelDataStorage


func _init() -> void:
	storage = LevelDataStorage.load_from_settings_path()
	if !storage:
		printerr('Failed to load level storage')
		return

func load_from_path(path:String, spawn:String, data = null):
	if !storage:
		return
	
	if !ResourceLoader.exists(path):
		printerr('%s does not exitst' % path)
		return
	
	var level_data:LevelData
	
	if !data:
		for lev_data in storage.get_data_list():
			if lev_data.level_path == path:
				level_data = lev_data
	
	level_data = data
	
	if !level_data:
		printerr('Failed to get level data')
		return
	
	loading_levels[level_data.label] = path
	level_datas[level_data.label] = level_data
	level_spawns[level_data.label] = spawn
	
	ResourceLoader.load_threaded_request(path)

func _process(delta: float) -> void:
	for label in loading_levels.keys():
		var load_status = ResourceLoader.load_threaded_get_status(loading_levels[label])
		
		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			_level_loaded(label)
			return
		if load_status == ResourceLoader.THREAD_LOAD_FAILED:
			_load_failed(label)
	
func load_from_data(data:LevelData, spawn:String):
	load_from_path(data.level_path, spawn, data)

func load_level_by_label(label:String, spawn:String):
	if !storage:
		return
	
	var data = storage.get_data_by_label(label)
	load_from_path(data.level_path, spawn, data)

func get_load_progress(label:String) -> int:
	if !loading_levels.has(label):
		return 0
	
	var progress = []
	ResourceLoader.load_threaded_get_status(loading_levels[label], progress)
	
	return progress[0] * 100

func get_loading_levels() -> Dictionary:
	if !loading_levels:
		return {}
	
	return loading_levels

func get_load_path(label:String) -> String:
	if !loading_levels:
		return ''
	
	return loading_levels.get(label, '')

func _set_level_change_data(level, data:LevelData, spawn:String):
	var change_data = LevelChangeData.new()
	change_data.change_args = {}
	change_data.level_data = data
	change_data.spawn_point = spawn
	
	level.level_change_data = change_data

func _level_loaded(label:String):
	var level_scene = ResourceLoader.load_threaded_get(loading_levels[label])
	if !level_scene:
		printerr('Failed loading Level %s' % label)
		return
	
	loading_levels.erase(label)
	
	var level_instance = level_scene.instantiate()
	if !level_instance:
		printerr('Failed instancing Level %s' % label)
		return
	
	_set_level_change_data(
		level_instance, 
		level_datas[label], 
		level_spawns[label]
	)
	
	level_datas.erase(label)
	
	level_spawns.erase(label)
	
	loaded.emit(label, level_instance)

func _load_failed(label:String):
	loading_levels.erase(label)
	level_datas.erase(label)
	level_spawns.erase(label)

	failed_load.emit(label)
