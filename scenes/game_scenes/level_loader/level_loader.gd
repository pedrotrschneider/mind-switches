extends Control

var _garbage;

export(Resource) onready var level1 = level1 as LevelData;


func _ready():
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	
	GameEvents.emit_fade_in_signal(0.6);
	GameEvents.emit_show_back_button_signal();

func _on_Button1_pressed():
	level1.initial_minds = [1, 2, 3, 4, 5, 6, 0, 8, 7, 9, 10];
	level1.initial_switches = [
		[0, 3], [3, 0],
		[3, 6], [6, 3],
		[0, 1], [1, 0],
		[3, 4], [4, 3],
		[7, 8], [8, 7],
		[1, 2], [2, 1],
		[4, 5], [5, 4],
	];
	
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_level_signal(level1);


func _on_back_button_pressed() -> void:
	GameEvents.emit_hide_back_button_signal();
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_main_menu_signal();
