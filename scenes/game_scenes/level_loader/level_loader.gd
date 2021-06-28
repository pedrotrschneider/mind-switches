#######################################################
# Script responsável por controlar o seletor de nívies
#######################################################

extends Control

var _garbage;

# Varipaveis do editor:
export(Resource) onready var level1 = level1 as LevelData; # Resource do nível 1
export(NodePath) onready var button1 = self.get_node(button1) as Button; # Referência ao botão do nível 1.


func _ready() -> void:
	# Conecta ao sinal do clique no botção de voltar.
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	
	# Conecta ao sinal do clique no botão do nível 1.
	_garbage = button1.connect("pressed", self, "_on_button1_pressed");
	
	GameEvents.emit_fade_in_signal(0.6); # Incia com um fade de 0.6 seg
	GameEvents.emit_show_back_button_signal(); # Mostra o botão de voltar


# Callbacks dos sinais:
# Responsável por lidar com o clique no botão do nível 1.
func _on_button1_pressed() -> void:
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_level_signal(level1);


# Responsável por lidar com o clique no botão de voltar.
func _on_back_button_pressed() -> void:
	GameEvents.emit_hide_back_button_signal();
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_main_menu_signal();
