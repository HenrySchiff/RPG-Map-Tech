@tool extends Node3D

@export var texture: CompressedTexture2D:
	set(new_texture):
		texture = new_texture
		_apply_texture()

func _ready():
	_apply_texture()

func _apply_texture():
	var mesh := $MeshInstance3D
	var mat = mesh.get_surface_override_material(0)

	# Ensure material is unique per instance
	if mat:
		mat = mat.duplicate()
	else:
		mat = StandardMaterial3D.new()

	mesh.set_surface_override_material(0, mat)
	mat.albedo_texture = texture
