extends Node

@export var player_control: Node3D
@export var player: Node3D
@export var enemy1: Node3D
@export var enemy2: Node3D

@export var control_window: Window
@export var display_window: Window

var world_environment: Environment = preload("res://world/resources/world_environment.tres")

var sync_cameras = [true]
var orthogonal_projection = [true]

var view_distance = [5.0]

const font_scale: float = 1.8

func _process(_delta):
	
	#ImGui.ShowDemoWindow()
	
	ImGui.Begin("Configuration")
	ImGui.SetWindowFontScale(font_scale)
	ImGui.SeparatorText("World")
	
	world_environment.background_color = color_picker("Background color", world_environment.background_color)
	
	color_picker_shader("Gradient color A", control_window.world.gradient_shader, "gradient_color_a")
	color_picker_shader("Gradient color B", control_window.world.gradient_shader, "gradient_color_b")
	
	ImGui.SeparatorText("Camera")
	ImGui.Checkbox("Sync cameras", sync_cameras)
	if ImGui.Checkbox("Orthogonal projection", orthogonal_projection):
		display_window.world.camera.is_orthogonal = orthogonal_projection[0]
		control_window.world.camera.is_orthogonal = orthogonal_projection[0]
	ImGui.End()
	
	ImGui.Begin("Entities")
	ImGui.SetWindowFontScale(font_scale)
	ImGui.SeparatorText("Player")
	#player_position = vector_step_input("Position", player_position)
	player.position_target = vector_step_input("Position", player.position_target)
	
	var view_range = [player.target_view_range]
	#if ImGui.SliderFloatEx("View distance", view_range, 5.0, 50.0, "%.1f"):
	if ImGui.InputFloatEx("View distance", view_range, 1.0, 1.0, "%.1f"):
		player.target_view_range = view_range[0]
	
	#if ImGui.Button("increase view"):
		#player.increase_view()
	
	ImGui.SeparatorText("Enemies")
	#enemy1.position = vector_step_input("Position", enemy1.position)
	#enemy2.position = vector_step_input("Position", enemy2.position)
	ImGui.End()

func color_picker(label: String, ref_color: Color) -> Color:
	var col := [ref_color.r, ref_color.g, ref_color.b]
	
	if ImGui.ColorEdit3(label, col):
		return Color(col[0], col[1], col[2])
	
	return ref_color

func color_picker_shader(label: String, shader: ShaderMaterial, param: String) -> void:
	var ref_color := shader.get_shader_parameter(param) as Color
	var col := [ref_color.r, ref_color.g, ref_color.b]
	
	if ImGui.ColorEdit3(label, col):
		shader.set_shader_parameter(param, Color(col[0], col[1], col[2]))

func vector_step_input(label: String, ref_vector: Vector3) -> Vector3:
	#id += 1
	var step: float = 1.0
	var fast_step: float = 1.0
	
	ImGui.PushID("VectorStepButtons")
	ImGui.PushItemWidth(ImGui.CalcItemWidth() / 3.0)
	
	ImGui.AlignTextToFramePadding()
	var x = [ref_vector.x]
	ImGui.TextColored(Color.RED, "x")
	ImGui.SameLine()
	if ImGui.InputFloatEx("##x", x, step, fast_step, "%.1f"):
		ref_vector.x = x[0]
	ImGui.SameLine()
	
	var y = [ref_vector.y]
	ImGui.TextColored(Color.GREEN, "y")
	ImGui.SameLine()
	if ImGui.InputFloatEx("##y", y, step, fast_step, "%.1f"):
		ref_vector.y = y[0]
	ImGui.SameLine()
#
	var z = [ref_vector.z]
	ImGui.TextColored(Color.ROYAL_BLUE, "z")
	ImGui.SameLine()
	if ImGui.InputFloatEx("##z", z, step, fast_step, "%.1f"):
		ref_vector.z = z[0]
	ImGui.SameLine()
	
	ImGui.SameLine()
	ImGui.Text(label)

	ImGui.PopItemWidth()
	ImGui.PopID()
	
	return ref_vector
