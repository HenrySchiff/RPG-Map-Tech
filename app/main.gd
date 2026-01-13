extends Node

const CONFIG_PATH: String = "user://config.cfg"
const INITIAL_WINDOW_SIZE: Vector2 = Vector2(1152, 648)

@onready var control_window: Window = $ControlWindow
@onready var display_window: Window = $DisplayWindow

@onready var control_cube = $ControlWindow/SubViewportContainer/SubViewport/World/Player/GraphCube

@onready var gui = $GUI

func _ready():
	get_tree().auto_accept_quit = false
	load_config()
	
	control_window.world.set_enable_clipping(false)
	control_cube.hide_faces = true
	
	display_window.close_requested.connect(save_and_quit)
	control_window.close_requested.connect(save_and_quit)
	
	control_window.title = "Control Window"
	display_window.title = "Display Window"
	
	ImGuiGD.SetMainViewport(control_window)

func _process(_delta):
	if gui.sync_cameras[0]:
		display_window.world.camera.sync_targets(control_window.world.camera)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_and_quit()

func load_config():
	var config = ConfigFile.new()
	var error = config.load(CONFIG_PATH)
	
	if error != OK:
		print(error)
		return
	
	display_window.position = config.get_value("window_settings", "display_window_pos", Vector2.ZERO)
	control_window.position = config.get_value("window_settings", "control_window_pos", Vector2.ZERO)
	display_window.size = config.get_value("window_settings", "display_window_size", INITIAL_WINDOW_SIZE)
	control_window.size = config.get_value("window_settings", "control_window_size", INITIAL_WINDOW_SIZE)

func save_and_quit():
	var config = ConfigFile.new()
	config.set_value("window_settings", "display_window_pos", display_window.position)
	config.set_value("window_settings", "control_window_pos", control_window.position)
	config.set_value("window_settings", "display_window_size", display_window.size)
	config.set_value("window_settings", "control_window_size", control_window.size)
	config.save(CONFIG_PATH)
	
	get_tree().quit()
