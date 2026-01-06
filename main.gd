extends Node

const CONFIG_PATH: String = "user://config.cfg"
const INITIAL_WINDOW_SIZE: Vector2 = Vector2(1152, 648)

@onready var window_a: Window = $ControlWindow
@onready var window_b: Window = $DisplayWindow
@onready var cube = $ControlWindow/SubViewportContainer/SubViewport/World/CameraContainer/Player/GraphCube

func _ready():
	get_tree().auto_accept_quit = false
	load_config()
	
	cube.hide_faces = true
	
	window_a.close_requested.connect(save_and_quit)
	window_b.close_requested.connect(save_and_quit)
	
	window_a.title = "Control Window"
	window_b.title = "Display Window"

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
