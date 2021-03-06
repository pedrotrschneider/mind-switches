extends Spatial

var _garbage;

export var _colors = [];
export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;

var _num_bodies: int;
var _bodies = [];
var _minds = [];
var _switches_buffer = [];
var _selected_bodies = [];
var _minds_solving_init_config = [];
var _switches_buffer_solving_init_config = [];

func _ready() -> void:
	_garbage = GameEvents.connect("body_selected", self, "_on_body_selected");
	_garbage = GameEvents.connect("confirm_button_pressed", self, "_on_confirm_button_pressed")
	_garbage = GameEvents.connect("finish_switches_button_pressed", self, "_on_finish_switches_button_pressed");
	_garbage = GameEvents.connect("reset_minds_button_pressed", self, "_on_reset_minds_button_pressed");
	
	_num_bodies = _colors.size();
	_bodies.resize(_num_bodies);
	_minds.resize(_num_bodies);
	
	var bodies = get_tree().get_nodes_in_group("Body");
	var i: int = 0;
	for body in bodies:
		body.index = i;
		body.mind_color = _colors[i];
		body.body_color = _colors[i];
		
		_bodies[i] = i;
		_minds[i] = i;
		i += 1;


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
			GameEvents.emit_hide_finish_switches_button_signal();
			GameEvents.emit_show_reset_minds_button_signal();
			_minds_solving_init_config = _minds.duplicate();
			_switches_buffer_solving_init_config = _switches_buffer.duplicate();
			var bodies = get_tree().get_nodes_in_group("Body");
			for body in bodies:
				body.show();


func _on_reset_minds_button_pressed() -> void:
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
	
	_selected_bodies.clear();
	_runtime_data.current_level_state = Enums.LevelStates.SELECTING;
	GameEvents.emit_hide_confirm_button_signal();
	
	if(_switches_buffer.size() > 1):
		GameEvents.emit_show_finish_switches_button_signal();
