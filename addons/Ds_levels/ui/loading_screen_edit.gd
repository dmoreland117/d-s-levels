@tool
extends VBoxContainer


@onready var loading_screens_table: VBoxContainer = %loading_screens_table


func _ready() -> void:
	refresh_loading_screen_list()
	
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
	
	LoadingScreenDataStorage.add_data('new_loading_screen', 'res://')
	refresh_loading_screen_list()

func _on_set_storage_button_pressed() -> void:
	PopupUtils.show_select_loading_screen_storage_path_popup()

func _on_visibility_changed() -> void:
	if !LoadingScreenDataStorage.is_storage_loaded() and visible:
		PopupUtils.show_select_loading_screen_storage_path_popup()
	
	refresh_loading_screen_list()
