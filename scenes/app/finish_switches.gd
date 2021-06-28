#######################################################
# Script que controla o funcionamento do botão de finalizar as trocas (usado
# dentro de algum nível)
#######################################################

extends Button

var _garbage;

func _ready() -> void:
	# Conectando ao próprio sinal de clique
	_garbage = self.connect("pressed", self, "_on_finish_switches_pressed");
	
	# Conetando aos sinais relevantes (veja a documentação do singleton GameEvents para descrições de cada um dos sinais)
	_garbage = GameEvents.connect("hide_finish_switches_button", self, "_on_hide_finish_switches_button");
	_garbage = GameEvents.connect("show_finish_switches_button", self,  "_on_show_finish_switches_button");


# Callbacks do sinais:
# Função chamada toda vez que o botão é pressionado.
# Emite o sinal do botão de finalizar trocas pressionado.
func _on_finish_switches_pressed() -> void:
	GameEvents.emit_finish_switches_button_pressed_signal();


# Esconde o botão.
func _on_hide_finish_switches_button() -> void:
	self.hide();


# Mostra o botão.
func _on_show_finish_switches_button() -> void:
	self.show();
