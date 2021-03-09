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
	_garbage = GameEvents.connect("fade_in", self, "_on_fade_in");
	_garbage = GameEvents.connect("fade_out", self, "_on_fade_out");


func _on_fade_in(duration: float) -> void:
	_fade_rect.show();
	_animation_player.play("FadeIn", -1, (1 / duration));
	yield(_animation_player, "animation_finished");
	_fade_rect.hide();


func _on_fade_out(duration: float) -> void:
	_fade_rect.show();
	_animation_player.play("FadeOut", -1, (1 / duration));
	yield(_animation_player, "animation_finished");
	_fade_rect.hide();


func _on_go_to_level() -> void:
	self.get_child(get_child_count() - 1).queue_free();
	
	var level_instance = _level_res.instance();
	self.add_child(level_instance);
