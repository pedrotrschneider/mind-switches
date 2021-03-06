extends Spatial

onready var _main_menu_res: Resource = preload("res://scenes/main_menu_scenes/main_menu/main_menu.tscn");


func _ready():
	var main_menu_instance = _main_menu_res.instance();
	self.add_child(main_menu_instance);
