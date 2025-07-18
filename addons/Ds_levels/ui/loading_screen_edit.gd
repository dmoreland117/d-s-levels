@tool
extends VBoxContainer


@onready var loading_screens_table: VBoxContainer = %loading_screens_table

var storage:LoadingScreenDataStorage


func _ready() -> void:
	refresh_loading_screen_list()
	
func _on_loading_screens_table_row_edited(index: int, data: Dictionary) -> void:
	if !storage:
		return
	
	storage.edit_data(index, data)
	refresh_loading_screen_list()

func refresh_loading_screen_list():
	if !storage:
		storage = LoadingScreenDataStorage.load_from_settings_path()
		if !storage:
			PopupUtils.show_error_popup('Could not load Storage.')
			return
	
	loading_screens_table.clear_table()
	
	for data in storage.get_data_list():
		loading_screens_table.add_row(data)

func _on_loading_screens_table_remove_pressed(index: int) -> void:
	if !storage:
		return
	
	storage.remove_data(index)
	refresh_loading_screen_list()

func _on_refresh_screens_button_pressed() -> void:
	refresh_loading_screen_list()


func _on_add_screen_butto_pressed() -> void:
	if !storage:
		return
	
	storage.add_data('new_loading_screen', 'res://')
	refresh_loading_screen_list()
