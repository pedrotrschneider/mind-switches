extends Spatial

var _garbage;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _area = get_node(_area) as Area;
export(NodePath) onready var _spot_light_animation_player = get_node(_spot_light_animation_player) as AnimationPlayer;
export(NodePath) onready var _spot_light = get_node(_spot_light) as SpotLight;


func _ready() -> void:
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");


func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
				GameEvents.emit_bookshelf_selected_signal();
				_area.hide();
				_spot_light_animation_player.play_backwards("SpotLight");
				yield(_spot_light_animation_player, "animation_finished");
				_spot_light.hide();


func _on_back_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
		_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
		GameEvents.emit_back_button_pressed_signal();
		_area.show();
		GameEvents.emit_hide_back_button_signal();
		_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
		_runtime_data.current_main_menu_state = Enums.MainMenuState.SELECTING;


func _on_Area_mouse_entered() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_spot_light.show();
		_spot_light_animation_player.play("SpotLight");


func _on_Area_mouse_exited() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_spot_light_animation_player.play_backwards("SpotLight");
		yield(_spot_light_animation_player, "animation_finished");
		_spot_light.hide();
