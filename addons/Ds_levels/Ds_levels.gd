@tool
extends EditorPlugin
class_name LevelManagerPlugin


const LEVELS_RESOURCE_PATH_SETTING = "ds_levels/directories/level_storage_path"
const LOADING_SCREENS_RESOURCE_PATH_SETTING = "ds_levels/directories/loading_screen_storage_path"
const DEFAULT_LEVELS_PATH = 'res://level_storage.tres'
const DEFAULT_LOADING_SCREENS_PATH = 'res://loading_screen_storage.tres'
const LEVEL_MANAGER_UI = preload("res://addons/Ds_levels/ui/level_manager_ui.tscn")

var main_screen_ui:Control

func _enter_tree() -> void:
	_add_resource_paths_to_project_settings()
	_add_main_screen_ui()

func _exit_tree() -> void:
	_remove_resource_path_from_project_settings()
	_remove_main_screen_ui()

func _get_plugin_name() -> String:
	return 'Levels'

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
	if ProjectSettings.has_setting(LEVELS_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(LEVELS_RESOURCE_PATH_SETTING, DEFAULT_LEVELS_PATH)
	ProjectSettings.add_property_info({
		'name': LEVELS_RESOURCE_PATH_SETTING,
		'type': TYPE_STRING,
		'hint': PROPERTY_HINT_FILE
	})
	
	if ProjectSettings.has_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING, DEFAULT_LOADING_SCREENS_PATH)
	ProjectSettings.add_property_info({
		'name': LOADING_SCREENS_RESOURCE_PATH_SETTING,
		'type': TYPE_STRING,
		'hint': PROPERTY_HINT_FILE
	})
	
func _remove_resource_path_from_project_settings():
	if !ProjectSettings.has_setting(LEVELS_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(LEVELS_RESOURCE_PATH_SETTING, null)
	
	if !ProjectSettings.has_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING):
		return
	
	ProjectSettings.set_setting(LOADING_SCREENS_RESOURCE_PATH_SETTING, null)
	
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
	
static func get_levels_storage_path() -> String:
	return ProjectSettings.get_setting(LevelManagerPlugin.LEVELS_RESOURCE_PATH_SETTING)

static func get_loading_screen_storage_path() -> String:
	return ProjectSettings.get_setting(LevelManagerPlugin.LOADING_SCREENS_RESOURCE_PATH_SETTING)
