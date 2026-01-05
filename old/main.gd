extends Node

const CONFIG_PATH: String = "user://config.cfg"
const INITIAL_WINDOW_SIZE: Vector2 = Vector2(1152, 648)

@onready var world_root: Node3D = $WorldRoot
@onready var window_a: Window = $WindowA
@onready var window_b: Window = $WindowB
@onready var vp_a: SubViewport = $WindowA/SubViewportContainer/SubViewport
@onready var vp_b: SubViewport = $WindowB/SubViewportContainer/SubViewport
@onready var camera_a: Node3D = $WindowA/SubViewportContainer/SubViewport/CameraContainer
@onready var player = %Player

func _ready():
	get_tree().auto_accept_quit = false
	load_config()
	
	var world := world_root.get_world_3d()
	vp_a.world_3d = world
	vp_b.world_3d = world
	
	vp_a.debug_draw = Viewport.DEBUG_DRAW_UNSHADED
	player.reparent(camera_a)
	
	window_a.close_requested.connect(save_and_quit)
	window_b.close_requested.connect(save_and_quit)
	
	window_a.title = "Dungeon Master View"
	window_b.title = "Player View"

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_and_quit()

func load_config():
	var config = ConfigFile.new()
	var error = config.load(CONFIG_PATH)
	
	if error != OK:
		print(error)
		return
	
	window_a.position = config.get_value("window_settings", "window_a_pos", Vector2.ZERO)
	window_b.position = config.get_value("window_settings", "window_b_pos", Vector2.ZERO)
	window_a.size = config.get_value("window_settings", "window_a_size", INITIAL_WINDOW_SIZE)
	window_b.size = config.get_value("window_settings", "window_b_size", INITIAL_WINDOW_SIZE)

func save_and_quit():
	var config = ConfigFile.new()
	config.set_value("window_settings", "window_a_pos", window_a.position)
	config.set_value("window_settings", "window_b_pos", window_b.position)
	config.set_value("window_settings", "window_a_size", window_a.size)
	config.set_value("window_settings", "window_b_size", window_b.size)
	config.save(CONFIG_PATH)
	
	get_tree().quit()
