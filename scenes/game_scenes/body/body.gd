extends Spatial

var _garbage;

export(NodePath) onready var _mind_mesh = get_node(_mind_mesh) as MeshInstance;
export(NodePath) onready var _body_mesh = get_node(_body_mesh) as CSGMesh;
export(NodePath) onready var _spot_light = get_node(_spot_light) as SpotLight;
export(NodePath) onready var _selectable_area = get_node(_selectable_area) as Area;

var index: int;
var mind_color: Color = Color.black setget _set_mind_color;
var body_color: Color = Color.black setget _set_body_color;
var _selected: bool = false;

func _ready() -> void:
	_garbage = GameEvents.connect("confirm_button_pressed", self, "_on_button_pressed");
	_garbage = GameEvents.connect("finish_switches_button_pressed", self, "_on_button_pressed");
	_garbage = GameEvents.connect("reset_minds_button_pressed", self, "_on_button_pressed");
	_garbage = GameEvents.connect("rejected_switch", self, "_on_rejected_switch");
	_garbage = GameEvents.connect("enable_body_area_visibility", self, "_on_enable_body_area_visibility");
	_garbage = GameEvents.connect("disable_body_area_visibility", self, "_on_disable_body_area_visibility");


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
			_selected = !_selected;
			GameEvents.emit_body_selected_signal(index);
			_spot_light.visible = _selected;


func _on_button_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout");
	_spot_light.hide();
	_selected = false;
	_spot_light.light_color = Color.white;


func _on_rejected_switch() -> void:
	_spot_light.light_color = Color.red;


func _on_enable_body_area_visibility() -> void:
	_selectable_area.show();


func _on_disable_body_area_visibility() -> void:
	if(!_selected):
		_selectable_area.hide();

