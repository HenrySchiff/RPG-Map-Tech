class_name Icon extends Node3D

enum IconType {
	DOT,
	CROSS
}

const dot_texture: Texture2D = preload("res://assets/dot.svg")
const cross_texture: Texture2D = preload("res://assets/cross.svg")

var label_text_buffer: Array[String] = [""]:
	set(value):
		label_text_buffer = value
		label_text = value[0]
		label.text = value[0]

@export var label_text: String
@export var icon_type: IconType = IconType.DOT
@export var target: Node3D = null

@export var color: Color = Color.RED:
	set(value):
		color = value
		call_deferred("_apply_color")

@onready var world: Node3D = find_parent("World")
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var line_node = $LineNode
@onready var line = $LineNode/Line
@onready var visible_area = $VisibleArea
@onready var clickable_area = $ClickableArea
@onready var label = $Label3D

signal clicked

func _ready():
	add_to_group("icons")
	
	#NOTE: make unqiue not working for some reason
	line.mesh = line.mesh.duplicate_deep()
	
	_apply_icon_type()
	
	label.text = label_text
	label_text_buffer = [label_text]
	#label_text_buffer.append("test")
	visible_area.connect("area_entered", _handle_area_entered)
	visible_area.connect("area_exited", _handle_area_exited)

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
	visible = !world.enable_clipping

func _apply_icon_type():
	match icon_type:
		IconType.DOT:
			sprite_3d.texture = dot_texture
			sprite_3d.scale = Vector3.ONE / 8.0
			sprite_3d.modulate = Color.BLACK
		IconType.CROSS:
			sprite_3d.texture = cross_texture
			sprite_3d.scale = Vector3.ONE / 24.0
			sprite_3d.modulate = color

func _apply_color():
	line.mesh.get_material().set_shader_parameter("line_color", color);
	sprite_3d.modulate = color

func set_target_pos(target_pos: Vector3) -> void:
	var distance: float = global_position.distance_to(target_pos)
	var midpoint: Vector3 = (global_position + target_pos) / 2
	line_node.global_position = midpoint
	line_node.look_at(target_pos)
	line.mesh.height = distance
	line.mesh.get_material().set_shader_parameter("line_length", distance);
