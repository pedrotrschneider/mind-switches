#######################################################
# Script responsável por controlar o funcionamento do botão de voltar
#######################################################

extends Button

var _garbage;

func _ready() -> void:
	# Conectando à propria animação de clique.
	_garbage = self.connect("pressed", self, "_on_back_button_pressed");
	
	# Conetando aos sinais relevantes (veja a documentação do singleton GameEvents para descrições de cada um dos sinais)
	_garbage = GameEvents.connect("show_back_button", self, "_on_show_back_button");
	_garbage = GameEvents.connect("hide_back_button", self, "_on_hide_back_button");


# Callbacks dos sinais:
# Função que é chamada toda vez que o botão é pressionado.
# Emite o sinal do botão de voltar pressionado
func _on_back_button_pressed() -> void:
	GameEvents.emit_back_button_pressed_signal();


# Mostra o botão de voltar
func _on_show_back_button() -> void:
	self.show();


# Esconde o botão de voltar
func _on_hide_back_button() -> void:
	self.hide();
