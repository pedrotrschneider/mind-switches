extends Spatial

var _garbage;

onready var _main_menu_res: Resource = preload("res://scenes/main_menu_scenes/main_menu/main_menu.tscn");
onready var _level_res: Resource = preload("res://scenes/game_scenes/level/level.tscn");

func _ready():
	var main_menu_instance = _main_menu_res.instance();
	self.add_child(main_menu_instance);
	
	_garbage = GameEvents.connect("go_to_level", self, "_on_go_to_level");


func _on_go_to_level() -> void:
	self.get_child(1).queue_free();
	
	var level_instance = _level_res.instance();
	self.add_child(level_instance);
