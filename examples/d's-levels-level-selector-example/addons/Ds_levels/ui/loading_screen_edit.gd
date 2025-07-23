@tool
extends VBoxContainer


@onready var loading_screens_table: VBoxContainer = %loading_screens_table
@onready var new_loading_screen_input: LineEdit = %new_loading_screen_input
@onready var new_loading_screen_path_picker: LineFilePicker = %new_loading_screen_path_picker
@onready var refresh_screens_button: Button = %refresh_screens_button
@onready var set_storage_button: Button = %set_storage_button
@onready var add_screen_butto: Button = %add_screen_butto


func _ready() -> void:
	refresh_loading_screen_list()
	_add_icons()

func _add_icons():
	if !Engine.is_editor_hint():
		return
	
	var editor_theme = EditorInterface.get_editor_theme()
	refresh_screens_button.icon = editor_theme.get_icon('Reload', 'EditorIcons')
	set_storage_button.icon = editor_theme.get_icon('ResourcePreloader', 'EditorIcons')
	add_screen_butto.icon = editor_theme.get_icon('Add', 'EditorIcons')

func _on_loading_screens_table_row_edited(index: int, data: Dictionary) -> void:
	if !LoadingScreenDataStorage.is_storage_loaded():
		return
	
	LoadingScreenDataStorage.edit_data(index, data)
	refresh_loading_screen_list()

func refresh_loading_screen_list():
	if !LoadingScreenDataStorage.is_storage_loaded():
		LoadingScreenDataStorage.load_from_settings_path()
		if !LoadingScreenDataStorage.is_storage_loaded():
			PopupUtils.show_error_popup('Could not load Storage.')
			return
	
	loading_screens_table.clear_table()
	
	for data in LoadingScreenDataStorage.get_data_list():
		loading_screens_table.add_row(data)

func _on_loading_screens_table_remove_pressed(index: int) -> void:
	if !LoadingScreenDataStorage.is_storage_loaded():
		return
	
	LoadingScreenDataStorage.remove_data(index)
	refresh_loading_screen_list()

func _on_refresh_screens_button_pressed() -> void:
	refresh_loading_screen_list()

func _on_add_screen_butto_pressed() -> void:
	if !LoadingScreenDataStorage.is_storage_loaded():
		return
	
	var new_screen_label = new_loading_screen_input.text
	var new_screen_path = new_loading_screen_path_picker.current_path
	
	if new_screen_label.is_empty():
		PopupUtils.show_error_popup('Please provide a Loading Screen Label.')
		return
	
	if new_screen_path.is_empty():
		PopupUtils.show_error_popup('Please provide a Loading Screen Path.')
		return
	
	if !ResourceLoader.exists(new_screen_path):
		PopupUtils.show_error_popup('%s does not exist.' % new_screen_path)
		return
	
	LoadingScreenDataStorage.add_data(new_screen_label, new_screen_path)
	
	new_loading_screen_input.text = ''
	new_loading_screen_path_picker.current_path = ''
	refresh_loading_screen_list()

func _on_set_storage_button_pressed() -> void:
	PopupUtils.show_select_loading_screen_storage_path_popup()

func _on_visibility_changed() -> void:
	if !LoadingScreenDataStorage.is_storage_loaded() and visible:
		PopupUtils.show_error_popup('Failed to load Loading Screen Storage\n%s' %LevelManagerPlugin.get_loading_screen_storage_path())

	refresh_loading_screen_list()
