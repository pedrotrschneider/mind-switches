extends Spatial

var _garbage;

export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer;
export(NodePath) onready var _fade_rect = get_node(_fade_rect) as ColorRect;

onready var _main_menu_res: Resource = preload("res://scenes/main_menu_scenes/main_menu/main_menu.tscn");
onready var _level_res: Resource = preload("res://scenes/game_scenes/level/level.tscn");

func _ready():
	var main_menu_instance = _main_menu_res.instance();
	self.add_child(main_menu_instance);
	
	_garbage = GameEvents.connect("go_to_level", self, "_on_go_to_level");
	_garbage = GameEvents.connect("door_selected", self, "_on_door_selected");


func _on_door_selected() -> void:
	_fade_rect.show();
	_animation_player.play("Fade", -1, (1 / 0.6));
	yield(_animation_player, "animation_finished");
	_fade_rect.hide();


func _on_go_to_level() -> void:
	self.get_child(get_child_count() - 1).queue_free();
	
	var level_instance = _level_res.instance();
	self.add_child(level_instance);
	
	_fade_rect.show();
	_animation_player.play_backwards("Fade");
	yield(_animation_player, "animation_finished");
	_fade_rect.hide();
