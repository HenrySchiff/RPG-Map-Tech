class_name World extends Node3D

@export var enable_clipping: bool = true
@export var icon_font_size: int = 80:
	set(value):
		icon_font_size = value
		if !is_inside_tree(): return
		for enemy in get_tree().get_nodes_in_group("icons"):
			enemy.label.font_size = icon_font_size

@onready var player: Player = $Player
@onready var camera: CameraRig = $CameraRig
@onready var meshes = $Meshes
@onready var enemies = $Enemies

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
			
	player.icon.clicked.connect(func(): camera.anchor = player.icon)
	
	for enemy in enemies.get_children():
		enemy.target = player
		enemy.clicked.connect(func(): camera.anchor = enemy)

func _process(_delta):
	solid_shader.set_shader_parameter("position", player.global_position)
	solid_shader.set_shader_parameter("visible_distance", player.view_range)
	gradient_shader.set_shader_parameter("position", player.global_position)
	gradient_shader.set_shader_parameter("visible_distance", player.view_range)
	
	if Input.is_action_just_pressed("click"):
		var cast = get_object_under_mouse()
		if !cast: return 
		
		var collider = cast.collider.get_parent() 
		if collider is Icon:
			collider.clicked.emit()

func set_enable_clipping(enabled: bool):
	enable_clipping = enabled
	solid_shader.set_shader_parameter("enable_clipping", enabled)
	gradient_shader.set_shader_parameter("enable_clipping", enabled)

func get_object_under_mouse():
	var cam := get_viewport().get_camera_3d()
	if cam == null: return null

	var mouse_pos = get_viewport().get_mouse_position()
	var from = cam.project_ray_origin(mouse_pos)
	var to = from + cam.project_ray_normal(mouse_pos) * 10000

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to, 2)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var result = space_state.intersect_ray(query)
	if result: return result
	
	return null
