extends Control

export(Resource) onready var level1 = level1 as LevelData;


func _ready():
	GameEvents.emit_fade_in_signal(0.6);

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
	GameEvents.emit_go_to_level_signal(level1);
