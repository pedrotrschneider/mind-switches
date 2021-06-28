#######################################################
# Sigleton resposável por lidar com os sinanis que podem ser de relevância para
# qualquer cena do jogo.
#######################################################

extends Node

#------------------------------------
# SIGNALS
#------------------------------------

# GLOBAL SIGNALS - sinais referentes ao funcionamento global do app
signal back_button_pressed; # Sinal se o botão de voltar for pressionado
signal show_back_button; # Sinal para mostrar o botão de voltar
signal hide_back_button; # Sinal para esconder o botão de voltar

signal confirm_button_pressed; # Sinal se o botão de confirmar for pressionado
signal hide_confirm_button; # Sinal para escoder o botão de confirmar
signal show_confirm_button; # Sinal para mostrar o botão de confirmar

signal finish_switches_button_pressed; # Sinal se o botão de finalizar as trocas for pressionado
signal hide_finish_switches_button; # Sinal para esconder o botão de finalizar as trocas
signal show_finish_switches_button; # Sinal para mostrar o botão de finalizar as trocas

signal reset_minds_button_pressed; # Sinal se o botão de resetar as mentes for pressionado
signal hide_reset_minds_button; # Sinal para esconder o botão de resetar as mentes
signal show_reset_minds_button; # Sinal para mostrar o botão de resetar as mentes

signal fade_in(duration); # Sinal para chamar uma animação de fade in (passado o tempo em segundos da annimação)
signal fade_out(duration); # Sinal para chamar uma animação de fade out (passado o tempo em segundos da animação)


# MAIN MENU SIGNALS - sinais referentes ao menu principal
signal bookshelf_selectd; # Sinal se a estante de livros for selecionada

signal book_selected(z_global_pos); # Sinal se a um livro específico for selecionado (passando o valor da posição do livro no eixo z)

signal door_selected; # Sinal se a porta for selecionada
signal open_door; # Sinal para abrir a porta
signal close_door; # Sinal para fechar a porta

signal game_type_level_selected; # Sinal se for escolhida a opção de jogar um nível ja pronto
signal game_type_sandbox_selected; # Sinal se for escolhida a opção de criar um nível sandbox


# GAME SIGNALS - sinais referentes ao jogo (level)
signal go_to_level(level_data); # Sinal para ir para um nível específico (passando o recurso referente aos dados do nível requerido)
signal go_to_sandbox_creator; # Sinal para ir para a cena de criador de level sandbox
signal go_to_level_loader; # Sinal para ir para a cena de selecionar nível
signal go_to_main_menu; # Sinal para ir para a cena de menu principal

signal body_selected(index); # Sinal se for selecionado um corpo (passado o indice inteiro desse corpo)
signal enable_body_area_visibility; # Sinal para permitir que o jogador selecione os corpos
signal disable_body_area_visibility; # Sinal para não permitir que o jogador selecione os corpos

signal rejected_switch; # Sinal se a troca for rejeitada


#------------------------------------
# EMITTERS - emissores são funções responsáveis apenas por emitir os sinais
# São úteis se for preciso realizar alguma operação com todos os sinais de um 
# tipo que forem emitidos.
# Via de regra, todos os sinais presentes nesse singleton precisam de um emissor
#------------------------------------


# GLOBAL EMITTERS - emissores dos sinais globais
func emit_back_button_pressed_signal() -> void:
	print("hello there")
	emit_signal("back_button_pressed");


func emit_show_back_button_signal() -> void:
	emit_signal("show_back_button");


func emit_hide_back_button_signal() -> void:
	emit_signal("hide_back_button");


func emit_confirm_button_pressed_signal() -> void:
	emit_signal("confirm_button_pressed");


func emit_hide_confirm_button_signal() -> void:
	emit_signal("hide_confirm_button");


func emit_show_confirm_button_signal() ->  void:
	emit_signal("show_confirm_button");


func emit_finish_switches_button_pressed_signal() -> void:
	emit_signal("finish_switches_button_pressed");


func emit_hide_finish_switches_button_signal() -> void:
	emit_signal("hide_finish_switches_button");

func emit_show_finish_switches_button_signal() -> void:
	emit_signal("show_finish_switches_button");


func emit_reset_minds_button_pressed_signal() -> void:
	emit_signal("reset_minds_button_pressed");


func emit_hide_reset_minds_button_signal() -> void:
	emit_signal("hide_reset_minds_button");


func emit_show_reset_minds_button_signal() -> void:
	emit_signal("show_reset_minds_button");


func emit_fade_in_signal(duration : float) -> void:
	emit_signal("fade_in", duration);


func emit_fade_out_signal(duration : float) -> void:
	emit_signal("fade_out", duration);


# MAIN MENU EMITTERS - emissores dos sinais de menu principal
func emit_bookshelf_selected_signal() -> void:
	emit_signal("bookshelf_selectd");


func emit_book_selected_signal(z_global_pos : float) -> void:
	emit_signal("book_selected", z_global_pos);


func emit_door_selected_signal() -> void:
	emit_signal("door_selected");


func emit_open_door_signal() -> void:
	emit_signal("open_door");


func emit_close_door_signal() -> void:
	emit_signal("close_door");


func emit_game_type_level_selected_signal() -> void:
	emit_signal("game_type_level_selected");


func emit_game_type_sandbox_selected_signal() -> void:
	emit_signal("game_type_sandbox_selected");


# GAME EMITTERS - emissores dos sinais do nível
func emit_go_to_level_signal(level_data : LevelData) -> void:
	emit_signal("go_to_level", level_data);


func emit_go_to_sandbox_creator_signal() -> void:
	emit_signal("go_to_sandbox_creator");


func emit_go_to_level_loader_signal() -> void:
	emit_signal("go_to_level_loader");



func emit_go_to_main_menu_signal() -> void:
	emit_signal("go_to_main_menu");

func emit_body_selected_signal(index : int) -> void:
	emit_signal("body_selected", index);


func emit_rejected_switch_signal() -> void:
	emit_signal("rejected_switch");


func emit_enable_body_area_visibility_signal() -> void:
	emit_signal("enable_body_area_visibility");


func emit_disable_body_area_visibility_signal() -> void:
	emit_signal("disable_body_area_visibility");
