@tool
extends VBoxContainer


signal edit_pressed(index:int)

@onready var levels_table: VBoxContainer = %levels_table
@onready var add_level_button: Button = %add_level_button
@onready var refresh_levels_button: Button = %refresh_levels_button
@onready var select_storage_path_button: Button = %select_storage_path_button


func _ready() -> void:
	if !LevelDataStorage.load_from_settings_path():
		printerr('Level_manager_ui Failed to load level storage')
		PopupUtils.show_select_storage_path_popup()
		return
	
	_add_icons()
	
	_populate_levels_list()

func _add_icons():
	var editor_theme = EditorInterface.get_editor_theme()
	add_level_button.icon = editor_theme.get_icon('Add', 'EditorIcons')
	refresh_levels_button.icon = editor_theme.get_icon('Reload', 'EditorIcons')
	select_storage_path_button.icon = editor_theme.get_icon('ResourcePreloader', 'EditorIcons')
	
func _populate_levels_list():
	levels_table.clear_table()
	
	if !levels_table:
		return
	
	if !LevelDataStorage.is_storage_loaded():
		return
	
	for level in LevelDataStorage.get_data_list():
		if LevelDataStorage.is_start_level(level):
			levels_table.add_row(level.label + ' (Start)', level.description, level.level_path)
			continue
			
		levels_table.add_row(level.label, level.description, level.level_path)

func _on_add_level_button_pressed() -> void:
	if !LevelDataStorage.is_storage_loaded():
		PopupUtils.show_error_popup('Please select Level Storage Path.')
		return
	
	PopupUtils.show_add_level_popup()

func _on_select_storage_path_button_pressed() -> void:
	PopupUtils.show_select_storage_path_popup()

func _on_visibility_changed() -> void:
	_populate_levels_list()

func _on_levels_table_remove_pressed(index: int) -> void:
	if !LevelDataStorage.is_storage_loaded():
		PopupUtils.show_error_popup('Error removing Level. Cant load Level Storage at path %s' % LevelManagerPlugin.get_levels_storage_path())
		return
	
	PopupUtils.show_remove_level_popup(index)

func _on_refresh_levels_button_pressed() -> void:
	if !LevelDataStorage.is_storage_loaded():
			PopupUtils.show_error_popup('Could not load LevelDataStorage from the provided path\n%s' % LevelManagerPlugin.get_levels_storage_path())
		
	_populate_levels_list()

func _on_levels_table_edit_pressed(index: int) -> void:
	edit_pressed.emit(index)

func _on_levels_table_open_pressed(index: int) -> void:
	if !LevelDataStorage.is_storage_loaded():
		PopupUtils.show_error_popup('Could not load LevelDataStorage from the provided path\n%s' % LevelManagerPlugin.get_levels_storage_path())
		return
	
	var data = LevelDataStorage.get_data_by_index(index)
	EditorInterface.open_scene_from_path(data.level_path)
