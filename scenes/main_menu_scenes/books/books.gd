#######################################################
# Script responsável por controlar a estante de livros
#######################################################

extends Spatial

var _garbage;

# Variáveis do editor:
export(Resource) onready var _runtime_data = _runtime_data as RuntimeData; # Veja a documentação do recurso de RuntimeData para mais informções.
export(NodePath) onready var _selectable_area = get_node(_selectable_area) as Area; # Referência à área selecionável.
export(NodePath) onready var _spot_light = get_node(_spot_light) as SpotLight; # Referência à SpotLight que ascende quando o mouse passa por cima da estante.
export(NodePath) onready var _spot_light_animation_player = get_node(_spot_light_animation_player) as AnimationPlayer; # Referência para o AnimationPlayer da SpotLight


func _ready() -> void:
	# Conecta aos sinais da área selecionável.
	_garbage = _selectable_area.connect("input_event", self, "_on_selectable_area_input_event");
	_garbage = _selectable_area.connect("mouse_entered", self, "_on_selectable_area_mouse_entered");
	_garbage = _selectable_area.connect("mouse_exited", self, "_on_selectable_area_mouse_exited");
	
	# Conecta ao sinal do clique no botão de voltar.
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");


# Callbacks do sinais:
# Responsável por lidar com InputEvents dentro da área selecionável.
func _on_selectable_area_input_event(_camera, event, _click_position, _click_normal, _shape_idx) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
				GameEvents.emit_bookshelf_selected_signal();
				_selectable_area.hide();
				_spot_light_animation_player.play_backwards("SpotLight");
				yield(_spot_light_animation_player, "animation_finished");
				_spot_light.hide();


# Responsável por lidar com quando o mouse entra denntro da área selecionável.
func _on_selectable_area_mouse_entered() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_spot_light.show();
		_spot_light_animation_player.play("SpotLight");


# Responsável por lidar com quando o mouse sai de denntro da área selecionável.
func _on_selectable_area_mouse_exited() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_spot_light_animation_player.play_backwards("SpotLight");
		yield(_spot_light_animation_player, "animation_finished");
		_spot_light.hide();


# Responsável por lidar com clique no botão de voltar.
func _on_back_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
		_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
		GameEvents.emit_back_button_pressed_signal();
		_selectable_area.show();
		GameEvents.emit_hide_back_button_signal();
		_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
		_runtime_data.current_main_menu_state = Enums.MainMenuState.SELECTING;
