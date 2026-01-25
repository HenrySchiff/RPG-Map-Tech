#NOTE: using node paths for GUI ID's. May break between frames if a node's path changes

extends Node

@export var control_window: CustomWindow
@export var display_window: CustomWindow

var world_environment: Environment = preload("res://world/resources/world_environment.tres")

var sync_cameras = [true]
var orthogonal_projection = [true]
var show_outline = [true]

var view_distance = [5.0]

const font_scale: float = 1.8

var speed_test = [1]

func _process(_delta):
	
	#ImGui.ShowDemoWindow()
	
	ImGui.Begin("Configuration")
	ImGui.SetWindowFontScale(font_scale)
	
	#ImGui.SeparatorText("Camera")
	if ImGui.TreeNode("Camera"):
		ImGui.Checkbox("Sync cameras", sync_cameras)
		if ImGui.Checkbox("Orthogonal projection", orthogonal_projection):
			display_window.camera.is_orthogonal = orthogonal_projection[0]
			control_window.camera.is_orthogonal = orthogonal_projection[0]
		ImGui.TreePop()
	
	
	#ImGui.SeparatorText("World")
	if ImGui.TreeNode("World"):
		color_picker("Background color", world_environment, "background_color")
		color_picker_shader("Gradient color A", control_window.world.gradient_shader, "gradient_color_a")
		color_picker_shader("Gradient color B", control_window.world.gradient_shader, "gradient_color_b")
		ImGui.TreePop()
	
	#ImGui.SeparatorText("Graph")
	if ImGui.TreeNode("Graph"):
		if ImGui.Checkbox("Show outline", show_outline):
			display_window.player.graph_cube.hide_outside_faces = !show_outline[0]
		color_picker_alpha("Face color", display_window.player.graph_cube, "face_color")
		float_slider("Cell length", display_window.player.graph_cube, "cell_length", 0.25, 4.0, "%.2f")
		color_picker("Line color", display_window.player.graph_cube, "line_color")
		float_slider("Line thickness", display_window.player.graph_cube, "line_thickness", 0.01, 0.20, "%.2f")
		color_picker("Edge color", display_window.player.graph_cube, "edge_color")
		float_slider("Edge thickness", display_window.player.graph_cube, "edge_thickness", 0.01, 0.20, "%.2f")
		ImGui.TreePop()
	
	if ImGui.TreeNode("Text"):
		int_slider("Icon font size", display_window.world, "icon_font_size", 32, 256)
		ImGui.TreePop()
	
	ImGui.End()
	
	ImGui.Begin("Entities")
	ImGui.SetWindowFontScale(font_scale)
	ImGui.SeparatorText("Player")
	display_window.player.position_target = vector_step_input("Position", display_window.player.position_target)
	
	var view_range = [display_window.player.target_view_range]
	if ImGui.InputFloatEx("View distance", view_range, 1.0, 1.0, "%.1f"):
		display_window.player.target_view_range = view_range[0]
		
	var speed = [display_window.player.movement_component.speed]
	if ImGui.InputFloatEx("Speed", speed, 1.0, 1.0, "%.1f"):
		display_window.player.movement_component.speed = clamp(speed[0], 2.0, 10.0)
	
	if ImGui.TreeNode("Enemies"):
		for enemy: Icon in control_window.world.enemies.get_children():
			if ImGui.TreeNode(str(enemy.get_path())):
				enemy.position = vector_step_input("Position", enemy.position, enemy.get_path())
				ImGui.InputText("Name", enemy.label_text_buffer, 32)
				enemy.label_text_buffer = enemy.label_text_buffer
				color_picker("Color", enemy, "color")
				ImGui.TreePop()
		ImGui.TreePop()
	ImGui.End()


func int_slider(label: String, object: Object, property_name: String, min_v, max_v):
	var property = [object.get(property_name)]
	if ImGui.SliderInt(label, property, min_v, max_v):
		object.set(property_name, property[0])

func float_slider(label: String, object: Object, property_name: String, min_v, max_v, format):
	var property = [object.get(property_name)]
	if ImGui.SliderFloatEx(label, property, min_v, max_v, format):
		object.set(property_name, property[0])

func color_picker(label: String, object: Object, property_name: String) -> void:
	var property: Color = object.get(property_name)
	var color := [property.r, property.g, property.b]
	
	if ImGui.ColorEdit3(label, color):
		object.set(property_name, Color(color[0], color[1], color[2]))

func color_picker_alpha(label: String, object: Object, property_name: String) -> void:
	var property: Color = object.get(property_name)
	var color := [property.r, property.g, property.b, property.a]
	
	if ImGui.ColorEdit4(label, color):
		object.set(property_name, Color(color[0], color[1], color[2], color[3]))

func color_picker_shader(label: String, shader: ShaderMaterial, param: String) -> void:
	var ref_color := shader.get_shader_parameter(param) as Color
	var col := [ref_color.r, ref_color.g, ref_color.b]
	
	if ImGui.ColorEdit3(label, col):
		shader.set_shader_parameter(param, Color(col[0], col[1], col[2]))

func vector_step_input(label: String, ref_vector: Vector3, id: String = "") -> Vector3:
	var step: float = 1.0
	var fast_step: float = 1.0
	
	ImGui.PushID(id)
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

#func text_input(label: String, string: String):
func text_input(label: String, object: Object, property_name: String, id: String = ""):
	var string = [object.get(property_name)]
	#var buffer = Array(string.split(""))
	
	ImGui.PushID(id)
	if ImGui.InputText(label, string, 32):
		object.set(property_name, string[0])
		#string = "".join(buffe
