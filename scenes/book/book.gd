extends Spatial

var _garbage;

var selected: bool = false;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer;
export(Color) var _albedo;

func _ready() -> void:
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	
	var _cover_material: SpatialMaterial = SpatialMaterial.new()
	_cover_material.albedo_color = _albedo;
	$"BookMesh/Spine/Spine".material_override = _cover_material;
	$"BookMesh/BackRotationPivot/BackCover/Cover".material_override = _cover_material;
	$"BookMesh/FrontRotationPivot/FrontCover/Cover".material_override = _cover_material;


func _on_SelectableArea_mouse_entered() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
		_animation_player.play("BookActive");


func _on_SelectableArea_mouse_exited() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
		_animation_player.play_backwards("BookActive");


func _on_SelectableArea_input_event(_camera, event, _click_position, _click_normal, _shape_idx) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
				GameEvents.emit_hide_back_button_signal();
				GameEvents.emit_book_selected_signal();
				_animation_player.play("BookSelected");
				yield(_animation_player, "animation_finished");
				_animation_player.play("BookOpen");
				yield(_animation_player, "animation_finished");
				GameEvents.emit_show_back_button_signal();
				_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
				_runtime_data.current_main_menu_state = Enums.MainMenuState.BOOK_SELECTED;
				selected = true;


func _on_back_button_pressed() -> void:
	if(selected):
		if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
			&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOK_SELECTED):
				_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
				GameEvents.emit_back_button_pressed_signal();
				GameEvents.emit_hide_back_button_signal();
				_animation_player.play_backwards("BookOpen");
				yield(_animation_player, "animation_finished");
				_animation_player.play_backwards("BookSelected");
				yield(_animation_player, "animation_finished");
				_animation_player.play_backwards("BookActive");
				yield(_animation_player, "animation_finished");
				GameEvents.emit_show_back_button_signal();
				_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
				_runtime_data.current_main_menu_state = Enums.MainMenuState.BOOKSHELF_SELECTED;
				selected = false;
