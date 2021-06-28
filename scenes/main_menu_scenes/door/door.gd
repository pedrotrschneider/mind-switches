#######################################################
# Script responsável por controlar a porta do menu principal
#######################################################

extends Spatial

var _garbage;

# Variáveis do editor:
export(Resource) onready var _runtime_data = _runtime_data as RuntimeData; # Veja a documentação do recurso RunntimeData para mais informações.
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer; # Referência ao AnimationPlayer da cena.
export(NodePath) onready var _selectable_area = get_node(_selectable_area) as Area; # Referência para a área selecionável da porta.


func _ready() -> void:
	# Conecta aos sinais da área selecionável:
	_garbage = _selectable_area.connect("mouse_entered", self, "_on_selectable_area_mouse_entered");
	_garbage = _selectable_area.connect("mouse_exited", self, "_on_selectable_area_mouse_exited");
	_garbage = _selectable_area.connect("input_event", self, "_on_selectable_area_input_event");
	
	# Conecta aos sinais relevantes (veja a documentação do singleton GameEvents para mais informações)
	_garbage = GameEvents.connect("open_door", self, "_on_open_door");
	_garbage = GameEvents.connect("close_door", self, "_on_close_door");


# Callbacks dos sinais:
# Responsável por lidar com o mouse entrando dentro da área selecionável.
# Toca a animação de abrir a porta.
func _on_selectable_area_mouse_entered():
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_animation_player.play("DoorOpen");


# Resposável por lidar com o mouse saindo da área selecionável.
func _on_selectable_area_mouse_exited():
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		_animation_player.play_backwards("DoorOpen");


# Responsável por lidar com InputEvents que acontecem dentro da área selecionável.
func _on_selectable_area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU \
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				GameEvents.emit_door_selected_signal();
				_runtime_data.current_gameplay_state = Enums.GameplayStates.ANIMATING;
				_runtime_data.current_main_menu_state = Enums.MainMenuState.DOOR_SELECTED;


func _on_open_door() -> void:
	_animation_player.play("DoorOpen");


func _on_close_door() -> void:
	_animation_player.play_backwards("DoorOpen");
