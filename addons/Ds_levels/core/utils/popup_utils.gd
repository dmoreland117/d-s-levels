class_name PopupUtils


const ADD_LEVEL_POPUP = preload("res://addons/Ds_levels/ui/popups/add_level_popup.tscn")
const ERROR_POPUP = preload("res://addons/Ds_levels/ui/popups/error_popup.tscn")
const LEVEL_STORAGE_PATH_SET_DIALOG = preload("res://addons/Ds_levels/ui/popups/level_storage_path_set_dialog.tscn")
const REMOVE_LEVEL_POPUP = preload("res://addons/Ds_levels/ui/popups/remove_level_popup.tscn")


static func show_select_storage_path_popup():
	var instance = LEVEL_STORAGE_PATH_SET_DIALOG.instantiate()
	var popup = PopupPanel.new()
	popup.borderless = false
	popup.size = Vector2(400, 200)
	popup.title = 'select storage path'
	popup.add_child( instance)
	
	EditorInterface.popup_dialog_centered(popup)

static func show_remove_level_popup(index:int):
	var instance = REMOVE_LEVEL_POPUP.instantiate()
	var popup = PopupPanel.new()
	popup.borderless = false
	popup.title = 'Remove Level'
	instance.index = index
	popup.add_child(instance)
	
	EditorInterface.popup_dialog_centered(popup)

static func show_add_level_popup():
	var instance = ADD_LEVEL_POPUP.instantiate()
	var popup = PopupPanel.new()
	popup.borderless = false
	popup.title = 'Add Level'
	popup.add_child(instance)
	
	EditorInterface.popup_dialog_centered(popup)

static func show_error_popup(error:String):
	var instance = ERROR_POPUP.instantiate()
	var popup = PopupPanel.new()
	popup.borderless = false
	popup.title = 'Error'
	instance.error_text = error
	popup.add_child(instance)
	
	EditorInterface.popup_dialog_centered(popup)
