#######################################################
# Script responsável por controlar o menu principal
#######################################################

extends Spatial

var _garbage;

# Variáveis do inspetor:
export(Resource) onready var _runtime_data = _runtime_data as RuntimeData; # veja a documentação do recurso RuntimeData para mais informações.
export(NodePath) onready var _camera_animation_player = get_node(_camera_animation_player) as AnimationPlayer; # Referência ao AnimationPlayer do menu principal.


func _ready() -> void:
	# Conecta aos sinais relevantes (veja a documentação do singleton GameEvents para mais informações):
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	_garbage = GameEvents.connect("bookshelf_selectd", self, "_on_bookshelf_selectd");
	_garbage = GameEvents.connect("book_selected", self, "_on_book_selected");
	_garbage = GameEvents.connect("door_selected", self, "_on_door_selected");
	_garbage = GameEvents.connect("game_type_level_selected", self, "_on_game_type_level_selected");
	_garbage = GameEvents.connect("game_type_sandbox_selected", self, "_on_game_type_sandbox_selected");
	
	GameEvents.emit_fade_in_signal(1); # começa com um fade de 1 seg


# Callbacks dos sinais:
# Responsável por lidar com o clique no botão de voltar.
func _on_back_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.ANIMATING):
		if(_runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
			_camera_animation_player.play_backwards("SelectedShelf");
		elif(_runtime_data.current_main_menu_state == Enums.MainMenuState.BOOK_SELECTED):
			_camera_animation_player.play_backwards("BookSelected");
	elif(_runtime_data.current_gameplay_state == Enums.GameplayStates.MAIN_MENU):
		if(_runtime_data.current_main_menu_state == Enums.MainMenuState.SELECTING_LEVEL_TYPE):
			GameEvents.emit_hide_back_button_signal();
			GameEvents.emit_open_door_signal();
			yield(get_tree().create_timer(0.2), "timeout");
			_camera_animation_player.play_backwards("DoorSelected");
			yield(_camera_animation_player, "animation_finished");
			_runtime_data.current_main_menu_state = Enums.MainMenuState.SELECTING;
			GameEvents.emit_close_door_signal();


# Responsável por lidar com quando a estante de livros é selecionada.
func _on_bookshelf_selectd() -> void:
	_camera_animation_player.play("SelectedShelf");
	yield(_camera_animation_player, "animation_finished");
	_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
	_runtime_data.current_main_menu_state = Enums.MainMenuState.BOOKSHELF_SELECTED;
	GameEvents.emit_show_back_button_signal();


# Responsável por lidar com quando um livro é selecionado.
func _on_book_selected(z_global_pos) -> void:
	var value: Vector3 = _camera_animation_player.get_animation("BookSelected").track_get_key_value(0, 2);
	value.z = z_global_pos;
	_camera_animation_player.get_animation("BookSelected").track_set_key_value(0, 2, value);
	_camera_animation_player.play("BookSelected");


# Resposável por lidar com quando a porta é selecionada.
func _on_door_selected() -> void:
	_camera_animation_player.play("DoorSelected");
	yield(_camera_animation_player, "animation_finished");
	GameEvents.emit_close_door_signal();
	_runtime_data.current_gameplay_state = Enums.GameplayStates.MAIN_MENU;
	_runtime_data.current_main_menu_state = Enums.MainMenuState.SELECTING_LEVEL_TYPE;
	GameEvents.emit_show_back_button_signal();


# Responsável por lidar com a seleção do tipo de seleção de level.
func _on_game_type_level_selected() -> void:
	GameEvents.emit_hide_back_button_signal();
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_level_loader_signal();


# Responsável por lidar com a seleção do tipo de jogo de Sandbox.
func _on_game_type_sandbox_selected() -> void:
	GameEvents.emit_hide_back_button_signal();
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_sandbox_creator_signal();
