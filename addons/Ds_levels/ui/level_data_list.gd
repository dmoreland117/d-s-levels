@tool
extends VBoxContainer


signal edit_pressed(index:int)

@onready var levels_table: VBoxContainer = %levels_table
@onready var add_level_button: Button = %add_level_button
@onready var refresh_levels_button: Button = %refresh_levels_button
@onready var select_storage_path_button: Button = %select_storage_path_button

var storage:LevelDataStorage


func _ready() -> void:
	_add_icons()
	
	_set_up_level_storage()
	
	if !storage:
		return
	
	levels_table.edit_pressed.connect(
		func(index):
			edit_pressed.emit(index)
	)
	
	_populate_levels_list()

func _add_icons():
	var editor_theme = EditorInterface.get_editor_theme()
	add_level_button.icon = editor_theme.get_icon('Add', 'EditorIcons')
	refresh_levels_button.icon = editor_theme.get_icon('Reload', 'EditorIcons')
	select_storage_path_button.icon = editor_theme.get_icon('ResourcePreloader', 'EditorIcons')

func _set_up_level_storage():
	storage = LevelDataStorage.load_from_settings_path()
	if !storage:
		return
	
	storage.data_updated.connect(_level_data_updated)

func _populate_levels_list():
	levels_table.clear_table()
	
	if !levels_table:
		return
	
	if !storage:
		return
	
	for level in storage.get_data_list():
		if storage.is_start_level(level):
			levels_table.add_row(level.label + ' (Start)', level.description, level.level_path)
			continue
			
		levels_table.add_row(level.label, level.description, level.level_path)

func _level_data_updated():
	if !storage:
		return
	
	if !levels_table:
		return

	levels_table.clear_table()
	_populate_levels_list()

func _on_add_level_button_pressed() -> void:
	if !storage:
		PopupUtils.show_error_popup('Please select Level Storage Path.')
		return
	
	PopupUtils.show_add_level_popup()

func _on_select_storage_path_button_pressed() -> void:
	PopupUtils.show_select_storage_path_popup()

func _on_visibility_changed() -> void:
	if !storage:
		_set_up_level_storage()
	
	if !levels_table:
		return
	
	levels_table.clear_table()
	_populate_levels_list()

func _on_levels_table_remove_pressed(index: int) -> void:
	if !storage:
		return
	
	PopupUtils.show_remove_level_popup(index)

func _on_refresh_levels_button_pressed() -> void:
	if !storage:
		_set_up_level_storage()
		
		if !storage:
			PopupUtils.show_error_popup('Could not load LevelDataStorage from the provided path\n%s' % LevelManagerPlugin.get_levels_storage_path())
			
	
	if !levels_table:
		return
	
	_populate_levels_list()


func _on_levels_table_edit_pressed(index: int) -> void:
	edit_pressed.emit(index)


func _on_levels_table_open_pressed(index: int) -> void:
	if !storage:
		return
	
	var data = storage.get_data_by_index(index)
	EditorInterface.open_scene_from_path(data.level_path)
