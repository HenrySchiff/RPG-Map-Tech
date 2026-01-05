extends Node3D

func _process(_delta):
	$FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	
	var box: MeshInstance3D = $Buildings/Box
	box.get_surface_override_material(0).set_shader_parameter("position", %GraphCube.global_position)
