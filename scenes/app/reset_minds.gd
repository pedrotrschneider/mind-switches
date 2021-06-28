#######################################################
# Script que controla o funcionamento do botão de resetar as mentes (usado
# dentro de algum nível).
#######################################################

extends Button

var _garbage;

func _ready() -> void:
	# Conectando ao própiro sinal de clique.
	_garbage = self.connect("pressed", self, "_on_reset_minds_pressed");
	
	# Conetando aos sinais relevantes (veja a documentação do singleton GameEvents para descrições de cada um dos sinais)
	_garbage = GameEvents.connect("hide_reset_minds_button", self, "_on_hide_reset_minds_button");
	_garbage = GameEvents.connect("show_reset_minds_button", self, "_on_show_reset_minds_button");
	pass


# Função chamada toda vez que o botão é pressionado.
# Emite o sinal de botão de resetar as mentes pressionado.
func _on_reset_minds_pressed() -> void:
	GameEvents.emit_reset_minds_button_pressed_signal();


# Callbacks dos sianis:
# Esconde o botão
func _on_hide_reset_minds_button() -> void:
	self.hide();


# Mostra o botão
func _on_show_reset_minds_button() -> void:
	self.show();
