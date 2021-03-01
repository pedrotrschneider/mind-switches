extends Spatial

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer;
export(NodePath) onready var _back_button = get_node(_back_button) as Button;

func _ready():
	pass


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				_animation_player.play("SelectedShelf");
				_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
				yield(_animation_player, "animation_finished");
				_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
				_runtime_data.current_main_menu_state = Enums.MainMenuState.SELECTED;
				_back_button.show();


func _on_BackButton_pressed():
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTED):
		_back_button.hide();
		_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
		_animation_player.play_backwards("SelectedShelf");
		yield(_animation_player, "animation_finished");
		_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
		_runtime_data.current_main_menu_state = Enums.MainMenuState.SELECTING;
