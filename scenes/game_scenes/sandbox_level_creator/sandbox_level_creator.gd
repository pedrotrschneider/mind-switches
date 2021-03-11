extends Control

export(NodePath) onready var _text_input = get_node(_text_input) as LineEdit;
export(Resource) onready var _level_data = _level_data as LevelData;

var _colors = [
	Color.red,
	Color.blue,
	Color.green,
	Color.cyan,
	Color.purple,
	Color.pink,
	Color.brown,
	Color.gray,
	Color.black,
	Color.white,
	Color.orange,
	Color.aliceblue
];


func _ready() -> void:
	GameEvents.emit_fade_in_signal(0.6);


func _on_Button_pressed():
	var num_bodies: int = int(_text_input.text);
	_level_data.num_bodies = num_bodies;
	_level_data.colors.resize(num_bodies + 2);
	_level_data.initial_minds.resize(num_bodies + 2);
	
	for b in (num_bodies + 2):
		_level_data.colors[b] = _colors[b];
		_level_data.initial_minds[b] = b;
	
	_level_data.initial_switches = [];
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_level_signal(_level_data);
