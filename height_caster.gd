class_name HeightCaster extends Node3D

const RAY_LENGTH: float = 1000.0

@onready var line: Line = $Line
@onready var decal: Decal = $Decal
@onready var viewport: SubViewport = $SubViewport
@onready var shader_rect: ColorRect = $SubViewport/ColorRect

func _ready():
	shader_rect.material = shader_rect.material.duplicate()
	decal.size.y = RAY_LENGTH * 2.0
	
	set_color(Color.BLACK)
	_update_texture()

func raycast():
	var space_state = get_world_3d().direct_space_state

	var ray_end := global_position + Vector3.DOWN * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(global_position, ray_end, 1)
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)
	if !result: return
	
	line.set_end_position(result.position)

func set_color(color: Color):
	line.color = color
	shader_rect.material.set_shader_parameter("circle_color", color)
	_update_texture()

func _update_texture():
	await RenderingServer.frame_post_draw
	decal.texture_albedo = viewport.get_texture()
