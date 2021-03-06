extends Spatial

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer;


func _ready() -> void:
	pass


func _on_Area_mouse_entered():
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_animation_player.play("DoorOpen");


func _on_Area_mouse_exited():
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_animation_player.play_backwards("DoorOpen");


func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				GameEvents.emit_door_selected_signal();
				_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
				_runtime_data.current_main_menu_state = Enums.MainMenuState.DOOR_SELECTED;
