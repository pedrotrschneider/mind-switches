extends Spatial

var _garbage;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer;
export(NodePath) onready var _fade_rect = get_node(_fade_rect) as ColorRect;

onready var _main_menu_res: Resource = preload("res://scenes/main_menu_scenes/main_menu/main_menu.tscn");
onready var _level_res: Resource = preload("res://scenes/game_scenes/level/level.tscn");
onready var _sandbox_creator_res: Resource = preload("res://scenes/game_scenes/sandbox_level_creator/sandbox_level_creator.tscn");
onready var _level_laoder_res: Resource = preload("res://scenes/game_scenes/level_loader/level_loader.tscn");

func _ready():
	_garbage = GameEvents.connect("go_to_level", self, "_on_go_to_level");
	_garbage = GameEvents.connect("go_to_sandbox_creator", self, "_on_go_to_sandbox_creator");
	_garbage = GameEvents.connect("go_to_level_loader", self, "_on_go_to_level_loader");
	_garbage = GameEvents.connect("go_to_main_menu", self, "_on_go_to_main_menu");
	_garbage = GameEvents.connect("fade_in", self, "_on_fade_in");
	_garbage = GameEvents.connect("fade_out", self, "_on_fade_out");
	
	var main_menu_instance = _main_menu_res.instance();
	self.add_child(main_menu_instance);


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


func _on_go_to_level(level_data: LevelData) -> void:
	self.get_child(get_child_count() - 1).queue_free();
	
	var level_instance = _level_res.instance();
	level_instance.level_data = level_data;
	self.add_child(level_instance);


func _on_go_to_sandbox_creator() -> void:
	self.get_child(get_child_count() - 1).queue_free();
	
	var sandbox_creator_instance = _sandbox_creator_res.instance();
	self.add_child(sandbox_creator_instance);
	
	_runtime_data.current_gameplay_state = Enums.GameplayStates.LEVEL;
	_runtime_data.current_level_state = Enums.LevelStates.SELECTING;


func _on_go_to_level_loader() -> void:
	self.get_child(get_child_count() - 1).queue_free();
	
	var level_loader_instance = _level_laoder_res.instance();
	self.add_child(level_loader_instance);
	
	_runtime_data.current_gameplay_state = Enums.GameplayStates.LEVEL;
	_runtime_data.current_level_state = Enums.LevelStates.SELECTING;


func _on_go_to_main_menu() -> void:
	self.get_child((get_child_count() - 1)).queue_free();
	
	var main_menu_instance = _main_menu_res.instance();
	self.add_child(main_menu_instance);
	
	_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
	_runtime_data.current_main_menu_state = Enums.MainMenuState.SELECTING;
