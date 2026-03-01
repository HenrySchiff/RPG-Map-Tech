class_name World extends Node3D

var movement_display_scene: PackedScene = preload("res://entity/movement_display.tscn")

@export var enable_clipping: bool = true
@export var icon_font_size: int = 80:
	set(value):
		icon_font_size = value
		if !is_inside_tree(): return
		for enemy in get_tree().get_nodes_in_group("icons"):
			enemy.label.font_size = icon_font_size

@onready var player: Player = $Player
@onready var camera: CameraRig = $CameraRig
@onready var objects = $Objects
@onready var enemies = $Enemies
@onready var movement_display = $MovementDisplay

@onready var terrain_mesh: MeshInstance3D = $Objects/terrain/lowpoly
@onready var terrain_collision: StaticBody3D = $Objects/terrain/StaticBody3D


var world_environment: Environment = preload("res://world/resources/world_environment.tres")

var solid_shader: ShaderMaterial = preload("res://world/resources/clip.tres").duplicate()
var gradient_shader: ShaderMaterial = preload("res://world/resources/gradient.tres").duplicate()

var hovered_icon: Icon
var selected_icon: Icon


func _ready():
	player.target_view_range = 12.0
	$WorldEnvironment.environment = world_environment
	set_enable_clipping(enable_clipping)
	
	for node in objects.find_children("*"):
		var shader = gradient_shader if node.is_in_group("gradient") else solid_shader
		
		if node is MeshInstance3D:
			node.set_surface_override_material(0, shader)
		if node is CSGBox3D:
			node.set_material(shader)
	
	terrain_mesh.create_trimesh_collision()
	terrain_mesh.get_child(0).reparent(terrain_collision)
	
	#player.icon.clicked.connect(_focus_on_entity.bind(player))
	
	#for enemy in enemies.get_children():
		#enemy.icon.target = player
		#enemy.icon.set_target(player)
		#enemy.icon.clicked.connect(_focus_on_entity.bind(enemy))

func _focus_on_entity(entity: Node3D):
	camera.anchor = entity
	
	remove_child(movement_display)
	movement_display.queue_free()
	
	movement_display = movement_display_scene.instantiate()
	movement_display.entity = entity
	add_child(movement_display)

func _process(_delta):
	solid_shader.set_shader_parameter("position", player.global_position)
	solid_shader.set_shader_parameter("visible_distance", player.view_range)
	gradient_shader.set_shader_parameter("position", player.global_position)
	gradient_shader.set_shader_parameter("visible_distance", player.view_range)
	
	if !get_window().has_focus(): return
	
	#FIXME: terrible code ahead
	
	var cast = get_object_under_mouse()
	if !cast:
		hovered_icon = null
		
		if Input.is_action_just_pressed("left_click"):
			player.icon.set_target(null)
		return 
	
	var collider = cast.collider.get_parent()
	if collider is Icon:
		hovered_icon = collider
	else:
		hovered_icon = null
	
	if Input.is_action_just_pressed("focus"):
		#hovered_icon.clicked.emit()
		if hovered_icon:
			_focus_on_entity(hovered_icon.get_parent())
	
	if Input.is_action_just_pressed("left_click"):
		if hovered_icon:
			collider.clicked.emit()
			if !movement_display.is_ancestor_of(collider):
				player.icon.set_target(collider)
			else:
				player.icon.set_target(null)
		
		else:
			player.icon.set_target(null)

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
