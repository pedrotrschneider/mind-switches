extends CSGBox

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;


func _ready():
	pass


func _on_HelmetArea1_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING_LEVEL_TYPE):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				GameEvents.emit_game_type_sandbox_selected_signal();


func _on_HelmetAera2_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING_LEVEL_TYPE):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				GameEvents.emit_game_type_level_selected_signal();
