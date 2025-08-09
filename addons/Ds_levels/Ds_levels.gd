@tool
extends EditorPlugin
class_name LevelManagerPlugin


const LEVELS_RESOURCE_PATH_SETTING = "ds_levels/directories/level_storage_path"
const LOADING_SCREENS_RESOURCE_PATH_SETTING = "ds_levels/directories/loading_screen_storage_path"
const TRANSITION_RESOURCE_PATH_SETTING = "ds_levels/directories/transition_storage_path"

const DEFAULT_LEVELS_PATH = 'res://addons/Ds_levels/default_data/level_storage.json'
const DEFAULT_LOADING_SCREENS_PATH = 'res://addons/Ds_levels/default_data/loading_screen_storage.json'
const DEFAULT_TRANSITION_PATH = 'res://addons/Ds_levels/default_data/transition_storage.json'

const LEVEL_MANAGER_UI = preload("res://addons/Ds_levels/ui/main_ui.tscn")

var main_screen_ui:Control
var current_level:Node
var save_level_preview_button:Button

var current_data:LevelData

func _enter_tree() -> void:
	_add_resource_paths_to_project_settings()
	_add_main_screen_ui()
	
	scene_changed.connect(_on_scene_changed)
	
	save_level_preview_button = Button.new()
	save_level_preview_button.text = 'Save Preview'
	save_level_preview_button.pressed.connect(_on_save_preview_button_pressed)

func _exit_tree() -> void:
	_remove_resource_path_from_project_settings()
	_remove_main_screen_ui()
	save_level_preview_button.queue_free()

func _get_plugin_name() -> String:
	return 'Levels'

func _get_plugin_icon() -> Texture2D:
	return load("res://addons/Ds_levels/icon.svg")

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if !main_screen_ui:
		return
	
	main_screen_ui.visible = visible

func _add_main_screen_ui():
	main_screen_ui = LEVEL_MANAGER_UI.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_screen_ui)
	main_screen_ui.hide()

func _remove_main_screen_ui():
	if !main_screen_ui:
		return
	
	main_screen_ui.queue_free()

func _add_resource_paths_to_project_settings():
	if !ProjectSettings.has_setting(LEVELS_RESOURCE_PATH_SETTING):
		ProjectSettings.set_setting(LEVELS_RESOURCE_PATH_SETTING, DEFAULT_LEVELS_PATH)
	
	if !ProjectSettings.has_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING):
		ProjectSettings.set_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING, DEFAULT_LOADING_SCREENS_PATH)
	
	if !ProjectSettings.has_setting(TRANSITION_RESOURCE_PATH_SETTING):
		ProjectSettings.set_setting(TRANSITION_RESOURCE_PATH_SETTING, DEFAULT_TRANSITION_PATH)
		
	ProjectSettings.add_property_info({
		'name': LEVELS_RESOURCE_PATH_SETTING,
		'type': TYPE_STRING,
		'hint': PROPERTY_HINT_FILE
	})
	ProjectSettings.add_property_info({
		'name': LOADING_SCREENS_RESOURCE_PATH_SETTING,
		'type': TYPE_STRING,
		'hint': PROPERTY_HINT_FILE
	})
	ProjectSettings.add_property_info({
		'name': TRANSITION_RESOURCE_PATH_SETTING,
		'type': TYPE_STRING,
		'hint': PROPERTY_HINT_FILE
	})
	
func _remove_resource_path_from_project_settings():
	if !ProjectSettings.has_setting(LEVELS_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(LEVELS_RESOURCE_PATH_SETTING, null)
	
	if ProjectSettings.has_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING):
		ProjectSettings.set_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING, null)
	
	if ProjectSettings.has_setting(TRANSITION_RESOURCE_PATH_SETTING):
		ProjectSettings.set_setting(TRANSITION_RESOURCE_PATH_SETTING, null)

func _add_save_button_to_toolbar():
	if !save_level_preview_button:
		return
	
	if current_level is Level2D:
		add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, save_level_preview_button)
	if current_level is Level3D:
		add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, save_level_preview_button)

func _remove_save_button_from_toolbar():
	if !save_level_preview_button:
		return
	
	if !save_level_preview_button.get_parent():
		return
	
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, save_level_preview_button)

func _on_save_preview_button_pressed():
	if !current_level:
		return
	
	if !current_data:
		return
	
	var texture
	if current_level is Level3D:
		texture = EditorInterface.get_editor_viewport_3d(0).get_texture().get_image()
	
	if current_level is Level2D:
		texture = EditorInterface.get_editor_viewport_2d().get_texture().get_image()
	
	var save_path = 'res://addons/Ds_levels/preview_cache/' + current_data.label + '_3d_prev_cache.png'
	
	var abs_path = ProjectSettings.globalize_path(save_path)
	if !DirAccess.dir_exists_absolute(abs_path):
		DirAccess.make_dir_absolute(ProjectSettings.globalize_path('res://addons/Ds_levels/preview_cache'))
	
	texture.save_png(save_path)
	current_data.preview_path = save_path
	LevelDataStorage.edit_data(LevelDataStorage.get_index_by_label(current_data.label), current_data)
	LevelDataStorage.save_at_settings_path()

func _on_scene_changed(scene):
	current_level = null
	current_data = null
	_remove_save_button_from_toolbar()
	
	if scene is Level2D:
		current_level = scene
		_add_save_button_to_toolbar()
		
	if scene is Level3D:
		current_level = scene
		_add_save_button_to_toolbar()
	
	if !current_level:
		return
	
	var path = current_level.scene_file_path
	
	current_data = LevelDataStorage.get_data_by_path(path)

func _on_scene_saved(path):
	pass

static func set_levels_storage_path(path:String):
	if !ProjectSettings.has_setting(LEVELS_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(LEVELS_RESOURCE_PATH_SETTING, path)
	ProjectSettings.save()

static func set_loading_screen_storage_path(path:String):
	if !ProjectSettings.has_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING, path)
	ProjectSettings.save()

static func set_transition_storage_path(path:String):
	if !ProjectSettings.has_setting(TRANSITION_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(TRANSITION_RESOURCE_PATH_SETTING, path)
	ProjectSettings.save()
	
static func get_levels_storage_path() -> String:
	return ProjectSettings.get_setting(LevelManagerPlugin.LEVELS_RESOURCE_PATH_SETTING)

static func get_loading_screen_storage_path() -> String:
	return ProjectSettings.get_setting(LevelManagerPlugin.LOADING_SCREENS_RESOURCE_PATH_SETTING)

static func get_transition_storage_path() -> String:
	return ProjectSettings.get_setting(LevelManagerPlugin.TRANSITION_RESOURCE_PATH_SETTING)
