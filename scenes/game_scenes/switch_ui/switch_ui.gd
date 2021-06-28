#######################################################
# Script responsável por controalar os quadrados da interface de trocas,
# que aparecem durante os níveis para ilustrar quais trocas já foram realizadas
#######################################################

extends Control

# Variáveis do editor
export(NodePath) onready var _rect1 = get_node(_rect1) as ColorRect; # ColorRect do primeiro qudrado
export(NodePath) onready var _rect2 = get_node(_rect2) as ColorRect; # ColorRect do segundo quadrado

var col1 : Color; # Cor do primeiro quadrado
var col2 : Color; # Cor do segundo quadrado


func _ready() -> void:
	# Seta a cor dos ColorRect para as cores que foram selecioandas
	_rect1.color = col1;
	_rect2.color = col2;
	
	# Como as cores são atualizadas apenas na função ready, as cores devem ser setadas
	# por meio da função set antes da instância da cena ser adicionada à árvore.


# Função setter para selescionar as cores dos quadrados
func set_colors(_col1 : Color, _col2 : Color) -> void:
	col1 = _col1;
	col2 = _col2;
