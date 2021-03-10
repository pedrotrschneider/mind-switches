extends Spatial

var _garbage;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(Resource) onready var _level_data = _level_data as LevelData;
export(NodePath) onready var _center_position = get_node(_center_position) as Position3D;
export(NodePath) onready var _extra1_position = get_node(_extra1_position) as Position3D;
export(NodePath) onready var _extra2_position = get_node(_extra2_position) as Position3D;


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
	
	_num_bodies = _level_data.num_bodies;
	_colors = _level_data.colors;
	
	_bodies.resize(_num_bodies + 2);
	_minds.resize(_num_bodies + 2);
	
	var r: float = 5;
	var sep: float = 360 / _num_bodies;
	var a: float = 0;
	for b in _num_bodies:
		var posX: float = _center_position.global_transform.origin.x + r * cos(deg2rad(a));
		var posZ: float = _center_position.global_transform.origin.z + r * sin(deg2rad(a));
		
		var body_instance = _body_scene_res.instance();
		self.add_child(body_instance);
		body_instance.global_transform.origin = Vector3(posX, 0, posZ);
		body_instance.index = b;
		body_instance.mind_color = _colors[b];
		body_instance.body_color = _colors[b];
#		body_instance.look_at(_center_position.global_transform.origin, Vector3.UP);
		
		_bodies[b] = b;
		_minds[b] = b;
		
		a += sep;
	
	var body_instance = _body_scene_res.instance();
	self.add_child(body_instance);
	body_instance.global_transform.origin = _extra1_position.global_transform.origin;
	body_instance.index = _num_bodies;
	body_instance.mind_color = _colors[_num_bodies];
	body_instance.body_color = _colors[_num_bodies];
	body_instance.hide();
	_bodies[_num_bodies] = _num_bodies;
	_minds[_num_bodies] = _num_bodies;
	
	body_instance = _body_scene_res.instance();
	self.add_child(body_instance);
	body_instance.global_transform.origin = _extra2_position.global_transform.origin;
	body_instance.index = _num_bodies + 1;
	body_instance.mind_color = _colors[_num_bodies + 1];
	body_instance.body_color = _colors[_num_bodies + 1];
	body_instance.hide();
	_bodies[_num_bodies + 1] = _num_bodies + 1;
	_minds[_num_bodies + 1] = _num_bodies + 1;


func _on_body_selected(index) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
		if(!_selected_bodies.has(index)):
			if(_selected_bodies.size() < 2):
				_selected_bodies.append(index);
		else:
			_selected_bodies.remove(_selected_bodies.find(index));
			GameEvents.emit_hide_confirm_button_signal();
		
		if(_selected_bodies.size() == 2):
			GameEvents.emit_show_confirm_button_signal();
		
		print(_selected_bodies);


func _on_confirm_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
			_runtime_data.current_level_state = Enums.LevelStates.SWITCHING;
			switch();


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
	_selected_bodies.clear();
	print(_minds_solving_init_config);
	var bodies = get_tree().get_nodes_in_group("Body");
	var i: int = 0;
	for body in bodies:
		body.mind_color = _colors[_minds_solving_init_config[i]];
		i += 1;
	
	_minds = _minds_solving_init_config.duplicate();
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
	else:
		print("troca rejeitada");
		GameEvents.emit_rejected_switch_signal();
	
	_selected_bodies.clear();
	_runtime_data.current_level_state = Enums.LevelStates.SELECTING;
	GameEvents.emit_hide_confirm_button_signal();
	
	if(_switches_buffer.size() > 1):
		GameEvents.emit_show_finish_switches_button_signal();
