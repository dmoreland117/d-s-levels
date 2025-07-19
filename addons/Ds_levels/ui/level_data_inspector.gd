@tool
extends VBoxContainer


@onready var level_label_input: LineEdit = %level_label_input
@onready var level_description_input: LineEdit = %level_description_input
@onready var level_path_picker: LineFilePicker = %level_path_picker
@onready var show_level_loading_screen_input: CheckBox = %show_level_loading_screen_input
@onready var margin_container: MarginContainer = %MarginContainer
@onready var loading_screen_background_picker: HBoxContainer = %loading_screen_background_picker
@onready var loading_screen_label_dropdown: OptionButton = %loading_screen_label_dropdown

var index:int = -1
var storage:LevelDataStorage
var data:LevelData


func _ready() -> void:
	storage = LevelDataStorage.load_from_settings_path()
	set_index(-1)
	
func set_index(idx:int):
	storage = LevelDataStorage.load_from_settings_path()
	
	index = idx
	
	if index == -1 or !storage:
		data = null
	
		level_label_input.text = ''
		level_description_input.text = ''
		level_path_picker.current_path = ''
		loading_screen_background_picker.current_path = ''
		loading_screen_label_dropdown.clear()
		margin_container.hide()
		
		return
	
	data = storage.get_data_by_index(index)
	
	level_label_input.text = data.label
	level_description_input.text = data.description
	level_path_picker.current_path = data.level_path
	show_level_loading_screen_input.button_pressed = data.show_loading_screen
	
	loading_screen_label_dropdown.clear()
	var loading_screen_storage = LoadingScreenDataStorage.load_from_settings_path()
	if !loading_screen_storage:
		return
	
	var loading_screen_datas = loading_screen_storage.get_data_list()
	for screen in loading_screen_datas:
		loading_screen_label_dropdown.add_item(screen.get('label', '[Error]'))
	
	loading_screen_label_dropdown.select(
		loading_screen_storage.get_index_by_label(data.loading_screen_name)
	)
	
	loading_screen_background_picker.current_path = data.loading_screen_background_path
	
	margin_container.show()

func _on_save_button_pressed() -> void:
	if !storage:
		return
		
	data.label = level_label_input.text
	data.description = level_description_input.text
	data.level_path = level_path_picker.current_path
	data.show_loading_screen = show_level_loading_screen_input.button_pressed
	data.loading_screen_background_path = loading_screen_background_picker.current_path
	data.loading_screen_name = loading_screen_label_dropdown.get_item_text(
		loading_screen_label_dropdown.selected
	)
	storage.edit_data(index, data)

func _on_reset_button_pressed() -> void:
	pass # Replace with function body.

func _on_clear_button_pressed() -> void:
	pass # Replace with function body.

func _on_set_default_button_pressed() -> void:
	if !storage:
		PopupUtils.show_error_popup('Failed to set default Level')
		return
	
	storage.set_start_level(index)
