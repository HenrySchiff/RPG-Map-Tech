class_name World extends Node3D

@export var enable_clipping: bool = true

@onready var player: Player = $Player
@onready var camera: CameraRig = $Player/CameraRig
@onready var meshes = $Meshes
@onready var icons = $Icons

var world_environment: Environment = preload("res://resources/world_environment.tres")
var clipping_shader: ShaderMaterial = preload("res://world/clip.tres").duplicate()

func _ready():
	#player.view_range = 50.0
	$WorldEnvironment.environment = world_environment
	set_enable_clipping(enable_clipping)
	
	for node in meshes.find_children("*"):
		if node is MeshInstance3D:
			node.set_surface_override_material(0, clipping_shader)
		if node is CSGBox3D:
			node.set_material(clipping_shader)
	
	for icon in icons.get_children():
		icon.target = player

func _process(_delta):
	clipping_shader.set_shader_parameter("position", player.global_position)
	clipping_shader.set_shader_parameter("visible_distance", player.view_range)

func set_enable_clipping(enabled: bool):
	enable_clipping = enabled
	clipping_shader.set_shader_parameter("enable_clipping", enabled)
