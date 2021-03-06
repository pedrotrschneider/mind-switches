extends Spatial

var _garbage;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer;
export(NodePath) onready var _spine_mesh = get_node(_spine_mesh) as MeshInstance;
export(NodePath) onready var _front_cover_mesh = get_node(_front_cover_mesh) as MeshInstance;
export(NodePath) onready var _back_cover_mesh = get_node(_back_cover_mesh) as MeshInstance;
export(Color) var _albedo;

var _selected: bool = false;

func _ready() -> void:
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	
	var _cover_material: SpatialMaterial = SpatialMaterial.new();
	_cover_material.albedo_color = _albedo;
	_spine_mesh.material_override = _cover_material;
	_front_cover_mesh.material_override = _cover_material;
	_back_cover_mesh.material_override = _cover_material;


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
				GameEvents.emit_book_selected_signal(self.global_transform.origin.z);
				_animation_player.play("BookSelected");
				yield(_animation_player, "animation_finished");
				_animation_player.play("BookOpen");
				yield(_animation_player, "animation_finished");
				GameEvents.emit_show_back_button_signal();
				_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
				_runtime_data.current_main_menu_state = Enums.MainMenuState.BOOK_SELECTED;
				_selected = true;


func _on_back_button_pressed() -> void:
	if(_selected):
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
				_selected = false;
