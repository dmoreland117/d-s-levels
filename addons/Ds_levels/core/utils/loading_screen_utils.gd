class_name LoadingScreenUtils


static func load_from_path(path:String, data:LevelData) -> LoadingScreen:
	if !ResourceLoader.exists(path):
		return
	
	var loading_screen_scene = load(path)
	if !loading_screen_scene:
		return
	
	var loading_screen_instance = loading_screen_scene.instantiate()
	loading_screen_instance.level_data = data
	
	return loading_screen_instance
	
