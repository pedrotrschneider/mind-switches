extends Spatial

export(NodePath) onready var _mind_mesh = get_node(_mind_mesh) as MeshInstance;
export(NodePath) onready var _body_mesh = get_node(_body_mesh) as CSGMesh;

var index;
var mind_color: Color = Color.black setget _set_mind_color;
var body_color: Color = Color.black setget _set_body_color;


func _set_mind_color(value: Color) -> void:
	mind_color = value;
	var _mind_material: SpatialMaterial = SpatialMaterial.new();
	_mind_material.albedo_color = mind_color;
	_mind_mesh.material_override = _mind_material;


func _set_body_color(value: Color) -> void:
	body_color = value;
	var _body_material: SpatialMaterial = SpatialMaterial.new();
	_body_material.albedo_color = body_color;
	_body_mesh.set_material(_body_material);


func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_LEFT && event.pressed):
			GameEvents.emit_body_selected_signal(index);
