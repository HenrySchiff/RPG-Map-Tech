extends Node3D

@export var enable_clipping: bool = true

@onready var player = %Player
@onready var meshes = $Meshes
@onready var icons = $Icons

var clipping_shader: ShaderMaterial = preload("res://clip.tres").duplicate()

func _ready():
	clipping_shader.set_shader_parameter("enable_clipping", enable_clipping)
	
	for node in meshes.find_children("*"):
		if node is MeshInstance3D:
			node.set_surface_override_material(0, clipping_shader)
		if node is CSGBox3D:
			node.set_material(clipping_shader)
	
	for icon in icons.get_children():
		icon.enable_clipping = enable_clipping
		icon.target = player

func _process(_delta):
	clipping_shader.set_shader_parameter("position", player.global_position)
	clipping_shader.set_shader_parameter("visible_distance", player.view_range)
