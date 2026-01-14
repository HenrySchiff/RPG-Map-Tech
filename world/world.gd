class_name World extends Node3D

@export var enable_clipping: bool = true

@onready var player: Player = $Player
@onready var camera: CameraRig = $Player/CameraRig
@onready var meshes = $Meshes
@onready var icons = $Icons

var world_environment: Environment = preload("res://world/resources/world_environment.tres")

var solid_shader: ShaderMaterial = preload("res://world/resources/clip.tres").duplicate()
var gradient_shader: ShaderMaterial = preload("res://world/resources/gradient.tres").duplicate()

func _ready():
	player.target_view_range = 12.0
	$WorldEnvironment.environment = world_environment
	set_enable_clipping(enable_clipping)
	
	for node in meshes.find_children("*"):
		var shader = gradient_shader if node.is_in_group("gradient") else solid_shader
		
		if node is MeshInstance3D:
			node.set_surface_override_material(0, shader)
		if node is CSGBox3D:
			node.set_material(shader)
	
	for icon in icons.get_children():
		icon.target = player

func _process(_delta):
	solid_shader.set_shader_parameter("position", player.global_position)
	solid_shader.set_shader_parameter("visible_distance", player.view_range)
	gradient_shader.set_shader_parameter("position", player.global_position)
	gradient_shader.set_shader_parameter("visible_distance", player.view_range)

func set_enable_clipping(enabled: bool):
	enable_clipping = enabled
	solid_shader.set_shader_parameter("enable_clipping", enabled)
	gradient_shader.set_shader_parameter("enable_clipping", enabled)
