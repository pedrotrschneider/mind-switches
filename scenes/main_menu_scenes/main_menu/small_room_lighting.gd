#######################################################
# Script resposnsável por lidar com a luz dentro do quarto da máquina
# no menu princnipal.
#######################################################

extends Spatial

# Variáveis do editor
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer; # Referência ao AnimaitonPlayer da luz

func _ready() -> void:
	_animation_player.play("OscilatingLight", -1, 0.2); # Toca a animação da luz oscilando.
