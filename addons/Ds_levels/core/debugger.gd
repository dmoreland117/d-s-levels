class_name DsDebugger
extends EditorDebuggerPlugin


const PLUGIN_UI = preload("res://addons/Ds_levels/ui/plugin_ui.tscn")

var session_id
var debug_ui:PluginUI


func _has_capture(capture):
	# Return true if you wish to handle messages with the prefix "my_plugin:".
	if capture == 'level_command': return true
	if capture == 'debug_command': return true
	if capture == 'level_ui_command': return true

func _capture(message, data, session_id):
	if message == "level_command:set_level":
		get_session(session_id).send_message(message, data)
		return true
	if message == "level_command:reload":
		get_session(session_id).send_message(message, data)
		return true
		
	if message == "debug_command:set_level":
		debug_ui.set_current_level(data[0])
		if !data[0].is_empty():
			get_session(session_id).send_message('level_ui_command:set_debug', [true])
		return true
	if message == "debug_command:update_load_level":
		debug_ui.set_loading_level_name(data[0])
		return true
	if message == "debug_command:update_load_progress":
		debug_ui.set_load_progress(data[0])
		return true
	if message == "debug_command:set_change_data":
		debug_ui.set_change_data(data[0], data[1])
		return true
	return false

func reload_current_level():
	get_session(session_id).send_message('level_command:reload', [])

func go_to_start_level():
	get_session(session_id).send_message('level_command:go_start', [])

func _setup_session(session_id):
	self.session_id = session_id
	# Add a new tab in the debugger session UI containing a label.
	var ui = PLUGIN_UI.instantiate()
	ui.reload_level_pressed.connect(reload_current_level)
	ui.go_to_start_level_pressed.connect(go_to_start_level)
	debug_ui = ui
	var session = get_session(session_id)
	
	# Listens to the session started and stopped signals.
	session.started.connect(func (): print("Session started"))
	session.stopped.connect(func (): 
		print("Session stopped")
		get_session(session_id).send_message('level_command:set_debug', [false])
	)
	session.add_session_tab(ui)
