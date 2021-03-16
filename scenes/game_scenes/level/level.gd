extends Spatial

var _garbage;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _center_position = get_node(_center_position) as Position3D;
export(Array, NodePath) var _extra_positions;
export(NodePath) onready var _vertical_box = get_node(_vertical_box) as VBoxContainer;

onready var _swtich_ui_res = preload("res://scenes/game_scenes/switch_ui/switch_ui.tscn");

var level_data:LevelData;
onready var _body_scene_res: Resource = preload("res://scenes/game_scenes/body/body.tscn");
var _num_bodies: int;
var _colors = [];
var _bodies = [];
var _minds = [];
var _switches_buffer = [];
var _selected_bodies = [];
var _minds_solving_init_config = [];
var _switches_buffer_solving_init_config = [];

func _ready() -> void:
	GameEvents.emit_fade_in_signal(0.6);
	
	_garbage = GameEvents.connect("body_selected", self, "_on_body_selected");
	_garbage = GameEvents.connect("confirm_button_pressed", self, "_on_confirm_button_pressed")
	_garbage = GameEvents.connect("finish_switches_button_pressed", self, "_on_finish_switches_button_pressed");
	_garbage = GameEvents.connect("reset_minds_button_pressed", self, "_on_reset_minds_button_pressed");
	
	_num_bodies = level_data.num_bodies;
	_colors = level_data.colors;
	
	_bodies.resize(_num_bodies + level_data.num_extras);
	_minds.resize(_num_bodies + level_data.num_extras);
	
	_minds = level_data.initial_minds;
	for b in (_num_bodies + level_data.num_extras):
		_bodies[b] = b;
	_switches_buffer = level_data.initial_switches;
	
	var r: float = 5;
	var sep: float = 360.0 / float(_num_bodies);
	var a: float = 0;
	for b in _num_bodies:
		var posX: float = _center_position.global_transform.origin.x + r * cos(deg2rad(a));
		var posZ: float = _center_position.global_transform.origin.z + r * sin(deg2rad(a));
		
		var body_instance = _body_scene_res.instance();
		self.add_child(body_instance);
		body_instance.global_transform.origin = Vector3(posX, 0, posZ);
		body_instance.index = b;
		body_instance.mind_color = _colors[_minds[b]];
		body_instance.body_color = _colors[b];
		
		a += sep;
	
	for e in level_data.num_extras:
		_extra_positions[e] = get_node(_extra_positions[e]) as Position3D;
		var body_instance = _body_scene_res.instance();
		self.add_child(body_instance);
		body_instance.global_transform.origin = _extra_positions[e].global_transform.origin;
		body_instance.index = _num_bodies + e;
		body_instance.mind_color = _colors[_minds[_num_bodies + e]];
		body_instance.body_color = _colors[_num_bodies + e];
		body_instance.hide();
	
	for s in _switches_buffer.size():
		if(s % 2 == 0):
			continue;
		
		_add_switches_ui(_colors[_switches_buffer[s][0]], _colors[_switches_buffer[s][1]]);
	
	if(level_data.level_type == Enums.LevelType.LEVEL):
		_on_finish_switches_button_pressed();


func _on_body_selected(index) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
		if(!_selected_bodies.has(index)):
			if(_selected_bodies.size() < 2):
				_selected_bodies.append(index);
				if(_selected_bodies.size() == 2):
					GameEvents.emit_disable_body_area_visibility_signal();
		else:
			GameEvents.emit_enable_body_area_visibility_signal();
			_selected_bodies.remove(_selected_bodies.find(index));
			GameEvents.emit_hide_confirm_button_signal();
		
		if(_selected_bodies.size() == 2):
			GameEvents.emit_disable_body_area_visibility_signal();
			GameEvents.emit_show_confirm_button_signal();
		
		print(_selected_bodies);


func _on_confirm_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
			_runtime_data.current_level_state = Enums.LevelStates.SWITCHING;
			switch();
			GameEvents.emit_enable_body_area_visibility_signal();


func _on_finish_switches_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
			_selected_bodies.clear();
			GameEvents.emit_hide_finish_switches_button_signal();
			GameEvents.emit_show_reset_minds_button_signal();
			_minds_solving_init_config = _minds.duplicate();
			_switches_buffer_solving_init_config = _switches_buffer.duplicate();
			var bodies = get_tree().get_nodes_in_group("Body");
			for body in bodies:
				body.show();


func _on_reset_minds_button_pressed() -> void:
	GameEvents.emit_hide_confirm_button_signal();
	GameEvents.emit_enable_body_area_visibility_signal();
	_selected_bodies.clear();
	print(_minds_solving_init_config);
	var bodies = get_tree().get_nodes_in_group("Body");
	var i: int = 0;
	for body in bodies:
		body.mind_color = _colors[_minds_solving_init_config[i]];
		i += 1;
	
	_minds = _minds_solving_init_config.duplicate();
	
	var switches_ui = _vertical_box.get_children();
	var dif = _switches_buffer.size() - _switches_buffer_solving_init_config.size();
	for j in dif / 2:
		switches_ui[_switches_buffer_solving_init_config.size() / 2 + j].queue_free();
	
	_switches_buffer = _switches_buffer_solving_init_config.duplicate();



func switch() -> void:
	if(!_switches_buffer.has(_selected_bodies)):
		var s = _selected_bodies.duplicate();
		_switches_buffer.append([s[0], s[1]]);
		_switches_buffer.append([s[1], s[0]]);
		
		var aux: int = _minds[_selected_bodies[0]];
		_minds[_selected_bodies[0]] = _minds[_selected_bodies[1]];
		_minds[_selected_bodies[1]] = aux;
		
		var bodies = get_tree().get_nodes_in_group("Body");
		var mind1 = _minds[_selected_bodies[0]];
		var mind2 = _minds[_selected_bodies[1]];
		for body in bodies:
			if(body.index == _selected_bodies[0]):
				body.mind_color = _colors[mind1];
			elif(body.index == _selected_bodies[1]):
				body.mind_color = _colors[mind2];
		
		print(_minds);
		print(_switches_buffer);
		_add_switches_ui(_colors[_selected_bodies[0]], _colors[_selected_bodies[1]]);
	else:
		print("troca rejeitada");
		GameEvents.emit_rejected_switch_signal();
	
	_selected_bodies.clear();
	_runtime_data.current_level_state = Enums.LevelStates.SELECTING;
	GameEvents.emit_hide_confirm_button_signal();
	
	if(_switches_buffer.size() > 1):
		GameEvents.emit_show_finish_switches_button_signal();


func _add_switches_ui(col1: Color, col2: Color):
	var switch_ui_instance = _swtich_ui_res.instance();
	switch_ui_instance.col1 = col1;
	switch_ui_instance.col2 = col2;
	
	_vertical_box.add_child(switch_ui_instance);
