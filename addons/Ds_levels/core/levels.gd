class_name Levels
## A static class that can change and unload [Levels]


const ARG_TRANSITION_NAME = 'transition_name'
const ARG_TRANSITION_SPEED = 'transition_speed'
const ARG_LOADING_SCREEN_NAME = 'loading_screen_name'
const ARG_SHOW_LOADING_SCREEN = 'show_loading_screen'

const DEFAULT_SPAWN_POINT = 'default'

static var _loading_screen_container:CanvasLayer
static var _loading_screen:LoadingScreen

static var _level_container:Node
static var _current_level:Node
static var _current_args:Dictionary

static var _transition_container:CanvasLayer
static var _current_transition:LevelTransition

static var _loader:LevelLoader


static func load_level_in_background():
	assert(false, 'This Methos is not implemented yet.')

## Unloads any current levels and changes to the provided [level] at [spawn] with [args].
static func change_to_level(level:LevelData, spawn:String = 'default', args:Dictionary = {}):
	_current_args = args
	
	var transition_speed_scale:float = args.get(ARG_TRANSITION_SPEED, 1.0)
	var transition_name:String = args.get(ARG_TRANSITION_NAME, 'fade')
	var loading_screen_name:String = args.get(ARG_LOADING_SCREEN_NAME, '')
	var show_loading_screen:bool = args.get(ARG_SHOW_LOADING_SCREEN, false)
	
	_current_transition = TransitionUtils.create_transition_instance(TransitionDataStorage.get_index_by_label(transition_name), transition_speed_scale)
	_add_transition_to_container()
	if _current_level:
		await _transition_out().show_next_level
		
		# start transition in 
		# wait for it to finish
		# delete the current level and transition in to the loading screen or next level
		_current_level.queue_free()
	
	_loader.load_from_data(level, spawn)
	
	if level.show_loading_screen or show_loading_screen:
		_transition_in()
		_show_loading_screen(level, loading_screen_name)

## Unloads the current level and loads the start level set in the Levels tab
## at [spawn] with [args].
static func change_to_start_level(spawn:String = 'default', args:Dictionary = {}):
	if !LevelDataStorage.is_storage_loaded():
		return
	
	var data = LevelDataStorage.get_start_level()
	change_to_level(data, spawn, args)

## Unloads any current levels and changes to the provided [label] at [spawn] with [args].
static func change_to_level_name(label:String, spawn:String = 'default', args:Dictionary = {}):
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
	if !_current_level:
		return
	
	return _current_level

## Returns the [LevelLoader] Node
static func get_loader() -> LevelLoader:
	if !_loader:
		return
	
	return _loader

static func _set_level_container(container:Node):
	EngineDebugger.register_message_capture('level_command', _on_debug_command)

	_loader = LevelLoader.new()
	_loader.name = 'Loader'
	_loader.loaded.connect(_on_level_loaded)
	
	_level_container = container
	container.add_child(_loader)
	
	_add_loading_screen_container()
	_add_transition_container()
	
	LevelDataStorage.load_from_settings_path()
	LoadingScreenDataStorage.load_from_settings_path()
	TransitionDataStorage.load_from_settings_path()
	

static func _on_level_loaded(label:String, level:Node):
	var data = level.get_level_data()
	
	_current_level = level
	_current_level.level_change_data.change_args = _current_args
	
	if _current_transition and _loading_screen:
		await _transition_out().transition_done

	_hide_loading_screen()
	
	_level_container.set_level(level)
	EngineDebugger.send_message('debug_command:set_level', [label])
	if _current_transition:
		await _transition_in().transition_done
	
	_free_current_transition()

static func _add_loading_screen_container():
	if !_level_container:
		return
	
	_loading_screen_container = CanvasLayer.new()
	_loading_screen_container.name = 'Loading Screens'
	_level_container.add_child(_loading_screen_container)

static func _show_loading_screen(data:LevelData, label:String = ''):
	if !_loading_screen_container or !_level_container:
		return
	
	var loading_screen_path = LoadingScreenDataStorage.get_data_by_label(data.loading_screen_name).get('path')
	if !label.is_empty():
		loading_screen_path = LoadingScreenDataStorage.get_data_by_label(label).get('path')
	
	if !loading_screen_path:
		return
	
	_loading_screen = LoadingScreenUtils.load_from_path(loading_screen_path, data)
	_loading_screen_container.add_child(_loading_screen)

static func _hide_loading_screen():
	if !_loading_screen_container:
		return
	
	if !_loading_screen:
		return
	
	_loading_screen_container.remove_child(_loading_screen)
	_loading_screen.queue_free()

static func _add_transition_container():
	if !_level_container:
		return
	
	var c = CanvasLayer.new()
	c.name = 'Transitions'
	_transition_container = c
	
	_level_container.add_child(c)
	
static func _transition_in() -> LevelTransition:
	if !_current_transition:
		return
	
	_current_transition.transition_in()
	return _current_transition

static func _transition_out() -> LevelTransition:
	if !_current_transition:
		return
	
	_current_transition.transition_out()
	return _current_transition

static func _add_transition_to_container():
	if !_transition_container:
		return
	
	if !_current_transition:
		return

	_transition_container.add_child(_current_transition)
	
static func _free_current_transition():
	for child in _transition_container.get_children():
		_transition_container.remove_child(child)
		child.queue_free()
	
	_current_transition = null

static func _on_debug_command(message:String, data) -> bool:
	if message == 'reload':
		if _current_level:
			change_to_level(_current_level.get_level_data(), _current_level.get_level_change_data().spawn_point, _current_level.get_level_change_data().change_args)
		return true
	if message == 'go_start':
		change_to_start_level()
	return false
