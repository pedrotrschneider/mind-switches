#######################################################
# Script responsável por controalr o funcionamento do botão de confirmar
#######################################################

extends Button

var _garbage;

func _ready() -> void:
	# Conectando ao próprio sinal de clique.
	_garbage = self.connect("pressed", self, "_on_confirm_button_pressed");
	
	# Conetando aos sinais relevantes (veja a documentação do singleton GameEvents para descrições de cada um dos sinais)
	_garbage = GameEvents.connect("hide_confirm_button", self, "_on_hide_confirm_button");
	_garbage = GameEvents.connect("show_confirm_button", self, "_on_show_confirm_button");


# Callbacks dos sinais:
# Função chamada toda vez que o botão é pressionado.
# Emite o sinal do botão de confirmar pressioado.
func _on_confirm_button_pressed() -> void:
	GameEvents.emit_confirm_button_pressed_signal();


# Esconde o botão de confirmar
func _on_hide_confirm_button() -> void:
	self.hide();


# Mostra o botão de confirmar
func _on_show_confirm_button() -> void:
	self.show();
