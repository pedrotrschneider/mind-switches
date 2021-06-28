#######################################################
# Script responsável por controlar o funcionamento dos livros no menu principal
#######################################################

extends Spatial

var _garbage;

# Variáveis do editor:
export(Resource) onready var _runtime_data = _runtime_data as RuntimeData; # Veja a documentação do recurso RuntimeData para entender melhor o funcionamento dele.
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer; # Referência ao AnimationPlayer do livro.
export(NodePath) onready var _spine_mesh = get_node(_spine_mesh) as MeshInstance; # Referência à MeshInstance da espinha do livro.
export(NodePath) onready var _front_cover_mesh = get_node(_front_cover_mesh) as MeshInstance; # Referência à MeshInstance da capa da frente do livro.
export(NodePath) onready var _back_cover_mesh = get_node(_back_cover_mesh) as MeshInstance; # Referência à MeshInstance da capa de trás do livro.
export(NodePath) onready var _selectable_area = get_node(_selectable_area) as Area; # Referência para a Area selecionavel do livro.
export(Color) var _albedo; # Cor do livro, que pode ser mudada pelo editor.

var _selected : bool = false; # Variável para guardar o estado do livro, entre selecionado (true) e não selecionado (false).

func _ready() -> void:
	 # Conecta ao sinal de clique do botão de voltar.
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	# Conecta aos sinais da Área selecionável.
	_garbage = _selectable_area.connect("mouse_entered", self, "_on_selectable_area_mouse_entered"); # Sinal quando o mouse entra na àrea.
	_garbage = _selectable_area.connect("mouse_exited", self, "_on_selectable_area_mouse_exited"); # Sinal quando o mouse sai da área.
	_garbage = _selectable_area.connect("input_event", self, "_on_selectable_area_input_event"); # Sinal quahndo acontece um InputEvent dentro da àrea.
	
	# Utiliza materias para mudar a cor do livro para a cor selecionada na variṕável _albedo.
	var _cover_material: SpatialMaterial = SpatialMaterial.new();
	_cover_material.albedo_color = _albedo;
	# Aplica o material com a cor selecionada à espinha, capa da frente e capa de tras.
	_spine_mesh.material_override = _cover_material;
	_front_cover_mesh.material_override = _cover_material;
	_back_cover_mesh.material_override = _cover_material;


# Callbacks dos sinais:
# Responsável por lidar com o mouse entrando dentro da área selecionável.
# Toca a animação do livro levantando.
func _on_selectable_area_mouse_entered() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
		_animation_player.play("BookActive");


# Responsável por lidar com o mouse saindo de dentro da área selecionável.
# Toca a animação do livro descendo.
func _on_selectable_area_mouse_exited() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU\
		&& _runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
		_animation_player.play_backwards("BookActive");


# Responsável por lidar com InputEvents dentro da àrea selecionável.
# Filtra o InputEvent para checar se é um clique do mouse, e se for, toca a animação
# do livro abrindo, e muda o estado do menu principal para o estado apropriado.
func _on_selectable_area_input_event(_camera, event, _click_position, _click_normal, _shape_idx) -> void:
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


# Responsável por lidar com cliques no botão de voltar.
# Vai rodar apenas se o livro estiver selecionado. Toca a animação
# de fechar o livro e retorna o jogo para o estado de escolher os livros.
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
