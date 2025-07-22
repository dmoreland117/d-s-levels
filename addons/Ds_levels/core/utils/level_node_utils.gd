class_name LevelNodeUtils


static func create_world_environment(env:Environment) -> WorldEnvironment:
	var we = WorldEnvironment.new()
	if !env:
		we.environment = Environment.new()
		return we
	
	we.environment = env
	return we

static func get_world_environment(level:Node) -> WorldEnvironment:
	for child in level.get_children():
		if child is WorldEnvironment:
			return child
	
	return

static func get_spawn_points(level:Node) -> Array:
	var ret = []
	for child in level.get_children():
		if child is SpawnPoint2D:
			ret.append(child)
		
		if child is SpawnPoint3D:
			ret.append(child)
	
	return ret

static func get_current_spawn_point(spawn_points:Array, spawn_point:String) -> Node:
	for point in spawn_points:
		if point.name == spawn_point:
			return point
	
	return

static func get_directional_light(level) -> Node:
	for child in level.get_children():
		if child is DirectionalLight2D:
			return child
		
		if child is DirectionalLight3D:
			return child
	
	return

static func create_player(path:String, spawn) -> Node:
	if !ResourceLoader.exists(path):
		return
	
	if !spawn:
		return
	
	var player_scene = load(path)
	if !player_scene:
		return
	
	var player_instance = player_scene.instantiate()
	if !player_instance:
		return
	
	player_instance.position = spawn.position
	player_instance.rotation = spawn.rotation
	
	return player_instance

static func has_world_environment(level) -> bool:
	for child in level.get_children():
		if child is WorldEnvironment:
			return true
	
	return false
