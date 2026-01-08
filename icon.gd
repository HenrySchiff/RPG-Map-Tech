class_name Icon extends Node3D

enum IconType {
	DOT,
	CROSS
}

const dot_texture: Texture2D = preload("res://assets/dot.svg")
const cross_texture: Texture2D = preload("res://assets/cross.svg")

@export var icon_type: IconType = IconType.DOT
@export var label_text: String = ""
@export var enable_clipping: bool = false
@export var target: Node3D = null

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var line_node = $LineNode
@onready var line = $LineNode/Line
@onready var area_3d = $Area3D
@onready var label = $Label3D

func _ready():
	_apply_icon_type()
	line.mesh = line.mesh.duplicate() #NOTE: make unqiue not working for some reason
	label.text = label_text
	area_3d.connect("area_entered", _handle_area_entered)
	area_3d.connect("area_exited", _handle_area_exited)

func _process(_delta):
	if !target: return
	set_target_pos(target.global_position)

func _handle_area_entered(area: Area3D):
	if !area.get_parent() is Player: return
	line.visible = target != null
	visible = true

func _handle_area_exited(area: Area3D):
	if !area.get_parent() is Player: return
	line.visible = false
	visible = !enable_clipping

func _apply_icon_type():
	match icon_type:
		IconType.DOT:
			sprite_3d.texture = dot_texture
			sprite_3d.scale = Vector3.ONE / 8.0
			sprite_3d.modulate = Color.BLACK
		IconType.CROSS:
			sprite_3d.texture = cross_texture
			sprite_3d.scale = Vector3.ONE / 24.0
			sprite_3d.modulate = line.get_surface_override_material(0).albedo_color

func set_target_pos(target_pos: Vector3) -> void:
	var distance: float = global_position.distance_to(target_pos)
	var midpoint: Vector3 = (global_position + target_pos) / 2
	line_node.global_position = midpoint
	line.mesh.height = distance
	line_node.look_at(target_pos)
