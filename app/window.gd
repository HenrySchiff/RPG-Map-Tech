class_name CustomWindow extends Window

@onready var sub_vp_container: SubViewportContainer = $SubViewportContainer
@onready var world: World = $SubViewportContainer/SubViewport/World
@onready var player: Player = $SubViewportContainer/SubViewport/World/Player
@onready var camera: CameraRig = $SubViewportContainer/SubViewport/World/CameraRig

func _process(_delta):
	$CanvasLayer/FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
