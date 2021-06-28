#######################################################
# Esse script controla o fucnionamento do criador de nível sandbox
#######################################################

extends Control

var _garbage;

# Variáveis do editor
export(Resource) onready var _level_data = _level_data as LevelData; # Recurso que guarda a LevelData do nível criado (tem um recurso padrao para levels sandbox na pasta de recursos, é esse que está sendo usado)
export(NodePath) onready var _num_bodies_input = get_node(_num_bodies_input) as LineEdit; # Referẽncia à caixa de texto de input do número de corpos
export(NodePath) onready var _num_extra_bodies_input = get_node(_num_extra_bodies_input) as LineEdit; # Referência à caixa de texto de input do número de corpos extra

# Array de cores possíveis para os corpos.
var _colors : Array = [
	Color.aliceblue,
	Color.antiquewhite, 
	Color.aqua, 
	Color.aquamarine, 
	Color.azure, 
	Color.beige, 
	Color.bisque, 
	Color.black, 
	Color.blanchedalmond, 
	Color.blue, 
	Color.blueviolet ,
	Color.brown,
	Color.burlywood, 
	Color.cadetblue, 
	Color.chartreuse, 
	Color.chocolate, 
	Color.coral, 
	Color.cornflower, 
	Color.cornsilk, 
	Color.crimson, 
	Color.cyan, 
	Color.darkblue, 
	Color.darkcyan, 
	Color.darkgoldenrod, 
	Color.darkgray, 
	Color.darkgreen, 
	Color.darkkhaki, 
	Color.darkmagenta, 
	Color.darkolivegreen,
	Color.darkorange, 
	Color.darkorchid, 
	Color.darkred, 
	Color.darksalmon, 
	Color.darkseagreen, 
	Color.darkslateblue, 
	Color.darkslategray, 
	Color.darkturquoise, 
	Color.darkviolet, 
	Color.deeppink, 
	Color.deepskyblue, 
	Color.dimgray, 
	Color.dodgerblue, 
	Color.firebrick, 
	Color.floralwhite,
	Color.forestgreen, 
	Color.fuchsia, 
	Color.gainsboro, 
	Color.ghostwhite, 
	Color.gold, 
	Color.goldenrod, 
	Color.gray, 
	Color.green, 
	Color.greenyellow, 
	Color.honeydew, 
	Color.hotpink, 
	Color.indianred, 
	Color.indigo, 
	Color.ivory, 
	Color.khaki, 
	Color.lavender, 
	Color.lavenderblush, 
	Color.lawngreen, 
	Color.lemonchiffon, 
	Color.lightblue, 
	Color.lightcoral, 
	Color.lightcyan, 
	Color.lightgoldenrod, 
	Color.lightgray, 
	Color.lightgreen, 
	Color.lightpink, 
	Color.lightsalmon, 
	Color.lightseagreen, 
	Color.lightskyblue, 
	Color.lightslategray, 
	Color.lightsteelblue, 
	Color.lightyellow, 
	Color.lime, 
	Color.limegreen, 
	Color.linen, 
	Color.magenta, 
	Color.maroon, 
	Color.mediumaquamarine, 
	Color.mediumblue, 
	Color.mediumorchid,
	Color.mediumpurple,
	Color.mediumseagreen, 
	Color.mediumslateblue, 
	Color.mediumspringgreen, 
	Color.mediumturquoise, 
	Color.mediumvioletred, 
	Color.midnightblue, 
	Color.mintcream, 
	Color.mistyrose, 
	Color.moccasin, 
	Color.navajowhite, 
	Color.navyblue, 
	Color.oldlace, 
	Color.olive, 
	Color.olivedrab, 
	Color.orange, 
	Color.orangered, 
	Color.orchid, 
	Color.palegoldenrod, 
	Color.palegreen, 
	Color.paleturquoise, 
	Color.palevioletred, 
	Color.papayawhip,
	Color.peachpuff, 
	Color.peru, 
	Color.pink, 
	Color.plum, 
	Color.powderblue, 
	Color.purple, 
	Color.rebeccapurple, 
	Color.red, 
	Color.rosybrown, 
	Color.royalblue, 
	Color.saddlebrown, 
	Color.salmon, 
	Color.sandybrown, 
	Color.seagreen, 
	Color.seashell, 
	Color.sienna, 
	Color.silver, 
	Color.skyblue, 
	Color.slateblue,
	Color.slategray, 
	Color.snow, 
	Color.springgreen, 
	Color.steelblue, 
	Color.teal, 
	Color.thistle, 
	Color.tomato, 
	Color.transparent, 
	Color.turquoise, 
	Color.violet, 
	Color.webgreen, 
	Color.webmaroon, 
	Color.webpurple, 
	Color.white, 
	Color.whitesmoke, 
	Color.yellow, 
	Color.yellowgreen
];


func _ready() -> void:
	# Conecta aos sinais relevantes (veja a documentação do singleton GameEvents para mais informações)
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	_garbage = GameEvents.connect("confirm_button_pressed", self, "_on_confirm_button_pressed")
	
	GameEvents.emit_fade_in_signal(0.6); # Começa com um fade in de 0.6 seg
	GameEvents.emit_show_back_button_signal(); # Mostra o botão de voltar
	GameEvents.emit_show_confirm_button_signal(); # Mostra o botão de confirmar
	
	_colors.shuffle(); # Embaralha aleatoriamente o array de cores para terem cores diferentes a cada vez que jogar.


# Callbacks dos sinais:
# Responsável por lidar com cliques no botão de confirmar.
# Preenche o recurso de level data e pede pra ir para aquele level.
func _on_confirm_button_pressed() -> void:
	var num_bodies: int = int(_num_bodies_input.text);
	var num_extra_bodies: int = int(_num_extra_bodies_input.text);
	_level_data.num_bodies = num_bodies;
	_level_data.num_extras = num_extra_bodies;
	_level_data.colors.resize(num_bodies + _level_data.num_extras);
	_level_data.initial_minds.resize(num_bodies + _level_data.num_extras);
	
	for b in (num_bodies + _level_data.num_extras):
		_level_data.colors[b] = _colors[b];
		_level_data.initial_minds[b] = b;
	
	_level_data.initial_switches = [];
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_level_signal(_level_data);


# Responsável por lidar com cliques no botão de voltar.
func _on_back_button_pressed() -> void:
	GameEvents.emit_hide_back_button_signal();
	GameEvents.emit_hide_confirm_button_signal();
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	GameEvents.emit_go_to_main_menu_signal();
