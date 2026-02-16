class_name Entity extends Node3D

@onready var movement_component: MovementComponent = $MovementComponent
@onready var icon: Icon = $Icon
@onready var height_caster: HeightCaster = $HeightCaster
#@onready var direction_vector = $DirectionVector

func _ready():
	height_caster.set_color(icon.color)

func _process(_delta):
	height_caster.raycast()
