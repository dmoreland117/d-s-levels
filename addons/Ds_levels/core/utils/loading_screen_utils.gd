class_name LoadingScreenUtils


static func load_from_path(path:String, data:LevelData) -> LoadingScreen:
	if !ResourceLoader.exists(path):
		return
	
	var loading_screen_scene = load(path)
	if !loading_screen_scene:
		return
	
	var loading_screen_instance = loading_screen_scene.instantiate()
	loading_screen_instance.level_data = data
	
	if ResourceLoader.exists(data.loading_screen_background_path):
		loading_screen_instance.background = load(data.loading_screen_background_path)
		
	return loading_screen_instance
