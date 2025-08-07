@tool
extends VBoxContainer


signal edit_pressed(index:int)

@onready var levels_table: VBoxContainer = %levels_table
@onready var add_level_button: Button = %add_level_button
@onready var refresh_levels_button: Button = %refresh_levels_button
@onready var select_storage_path_button: Button = %select_storage_path_button
@onready var new_level_label_input: LineEdit = %new_level_label_input
@onready var new_level_path_picker: LineFilePicker = %new_level_path_picker


func _ready() -> void:
	if !LevelDataStorage.load_from_settings_path():
		return
	
	_populate_levels_list()
	_add_icons()

func _add_icons():
	if !Engine.is_editor_hint():
		return
	
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
	
	for level in LevelDataStorage.get_data_list(true):
		var row_control:Control
		if LevelDataStorage.is_start_level(level):
			row_control = levels_table.add_row(level.label + ' (Start)', level.description, level.level_path)
		else:
			row_control = levels_table.add_row(level.label, level.description, level.level_path)
			
		if level.hidden:
			row_control.modulate = row_control.modulate.darkened(0.4)

func _on_add_level_button_pressed() -> void:
	if !LevelDataStorage.is_storage_loaded():
		PopupUtils.show_error_popup('Please select Level Storage Path.')
		return
	
	var new_level_data:LevelData = LevelData.new()
	
	if new_level_label_input.text.is_empty():
		PopupUtils.show_error_popup('Please provide a level name')
		return
	
	new_level_data.label = new_level_label_input.text
	
	if !ResourceLoader.exists(new_level_path_picker.current_path):
		PopupUtils.show_error_popup('%s Does not exits' % new_level_path_picker.current_path)
		return
		
	new_level_data.level_path = new_level_path_picker.current_path
	
	LevelDataStorage.add_data(new_level_data)
	
	new_level_label_input.text = ''
	new_level_path_picker.start_path = ''
	
	_populate_levels_list()

func _on_select_storage_path_button_pressed() -> void:
	await PopupUtils.show_select_storage_path_popup().tree_exited
	_populate_levels_list()

func _on_visibility_changed() -> void:
	_populate_levels_list()

func _on_levels_table_remove_pressed(index: int) -> void:
	if !LevelDataStorage.is_storage_loaded():
		PopupUtils.show_error_popup('Error removing Level. Cant load Level Storage at path %s' % LevelManagerPlugin.get_levels_storage_path())
		return
	
	await PopupUtils.show_remove_level_popup(index).tree_exited
	_populate_levels_list()

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
