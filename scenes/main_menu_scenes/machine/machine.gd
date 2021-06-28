#######################################################
# Script responsável por lidar com a máquina de troca de mentes
# presente no menu principal, em que se seleciona o tipo de nível.
#######################################################

extends CSGBox

var _garbage;

# Variáveis do editor:
export(Resource) onready var _runtime_data = _runtime_data as RuntimeData; # Veja a documentação do recurso RuntimeData para mais informações.
export(NodePath) onready var _helmet1_selectable_area = self.get_node(_helmet1_selectable_area) as Area; # Referência para a área selecionável do capacete 1
export(NodePath) onready var _helmet2_selectable_area = self.get_node(_helmet2_selectable_area) as Area; # Referência para a área selecionável do capacete 2


func _ready() -> void:
	# Conecta aos sinais da área dos dois capacetes.
	_garbage = _helmet1_selectable_area.connect("input_event", self, "_on_helmet1_selectable_area_input_event");
	_garbage = _helmet2_selectable_area.connect("input_event", self, "_on_helmet2_selectable_area_input_event");


# Callbacks do sinais:
# Responsável por lidar com InputEvents dentro da área do capacete 1.
func _on_helmet1_selectable_area_input_event(_camera, event, _click_position, _click_normal, _shape_idx) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING_LEVEL_TYPE):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				GameEvents.emit_game_type_sandbox_selected_signal();


# Resposável por lidar com InputEvents dentro da área do capaecete 2.
func _on_helmet2_selectable_area_input_event(_camera, event, _click_position, _click_normal, _shape_idx) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING_LEVEL_TYPE):
		if(event is InputEventMouseButton):
			if(event.button_index == BUTTON_LEFT && event.pressed):
				GameEvents.emit_game_type_level_selected_signal();
