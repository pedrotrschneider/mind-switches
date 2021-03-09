extends Spatial

var _garbage;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _camera_animation_player = get_node(_camera_animation_player) as AnimationPlayer;


func _ready() -> void:
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	_garbage = GameEvents.connect("bookshelf_selectd", self, "_on_bookshelf_selectd");
	_garbage = GameEvents.connect("book_selected", self, "_on_book_selected");
	_garbage = GameEvents.connect("door_selected", self, "_on_door_selected");


func _on_back_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.ANIMATING):
		if(_runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
			_camera_animation_player.play_backwards("SelectedShelf");
		elif(_runtime_data.current_main_menu_state == Enums.MainMenuState.BOOK_SELECTED):
			_camera_animation_player.play_backwards("BookSelected");


func _on_bookshelf_selectd() -> void:
	_camera_animation_player.play("SelectedShelf");
	yield(_camera_animation_player, "animation_finished");
	_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
	_runtime_data.current_main_menu_state = Enums.MainMenuState.BOOKSHELF_SELECTED;
	GameEvents.emit_show_back_button_signal();


func _on_book_selected(z_global_pos) -> void:
	var value: Vector3 = _camera_animation_player.get_animation("BookSelected").track_get_key_value(0, 2);
	value.z = z_global_pos;
	_camera_animation_player.get_animation("BookSelected").track_set_key_value(0, 2, value);
	_camera_animation_player.play("BookSelected");


func _on_door_selected() -> void:
	GameEvents.emit_fade_out_signal(0.6);
	_camera_animation_player.play("DoorSelected");
	yield(_camera_animation_player, "animation_finished");
	_runtime_data.current_gameplay_state = Enums.GameplayStates.LEVEL;
	GameEvents.emit_go_to_level_signal();
