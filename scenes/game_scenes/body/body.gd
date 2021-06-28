#######################################################
# Script que controla o funcionamento de um corpo dentro de algum nível
#######################################################

extends Spatial

var _garbage;

# Vareiáveis do editor
export(NodePath) onready var _mind_mesh = get_node(_mind_mesh) as MeshInstance; # Referencia à MeshInstance da "mente" (a bolinha que fica na cabeça que representa a mente)
export(NodePath) onready var _body_mesh = get_node(_body_mesh) as CSGMesh; # Referência à CSGMesh do corpo
export(NodePath) onready var _spot_light = get_node(_spot_light) as SpotLight; # Referẽncia à SpotLight que é ascendida quando o corpo é selecionado
export(NodePath) onready var _selectable_area = get_node(_selectable_area) as Area; # Referência à área que o jogador pode clicar para selecionar o corpo

var index : int; # Índice inteiro do corpo.
var mind_color : Color = Color.black setget _set_mind_color; # Cor atual da mentes.
var body_color : Color = Color.black setget _set_body_color; # Cor atual do corpo.
var _selected : bool = false; # Guarda o estado do corpo entre selecionado (true) e não selecionado (false).

func _ready() -> void:
	self.add_to_group("Body")
	
	# Conectando aos sinais relevantes (veja a documentação do singleton GameEvents para descrições dos sinais).
	_garbage = GameEvents.connect("confirm_button_pressed", self, "_on_button_pressed");
	_garbage = GameEvents.connect("finish_switches_button_pressed", self, "_on_button_pressed");
	_garbage = GameEvents.connect("reset_minds_button_pressed", self, "_on_button_pressed");
	_garbage = GameEvents.connect("rejected_switch", self, "_on_rejected_switch");
	_garbage = GameEvents.connect("enable_body_area_visibility", self, "_on_enable_body_area_visibility");
	_garbage = GameEvents.connect("disable_body_area_visibility", self, "_on_disable_body_area_visibility");


# Seta a cor da "mente".
func _set_mind_color(value : Color) -> void:
	mind_color = value;
	var _mind_material: SpatialMaterial = SpatialMaterial.new();
	_mind_material.albedo_color = mind_color;
	_mind_mesh.material_override = _mind_material;


# Seta a cor do corpo.
func _set_body_color(value : Color) -> void:
	body_color = value;
	var _body_material: SpatialMaterial = SpatialMaterial.new();
	_body_material.albedo_color = body_color;
	_body_mesh.set_material(_body_material);


# Função chamada toda vez que o jogador clicar em cima do corpo.
# Seleciona o corpo, caso ele nao esteja selecionado ainda, ou desseleciona
# caso ja esteja selecionado (muda o valor da variável de estado e esconde/mostra a spotlight).
func _on_Area_input_event(_camera, event, _click_position, _click_normal, _shape_idx) -> void:
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_LEFT && event.pressed):
			_selected = !_selected;
			GameEvents.emit_body_selected_signal(index);
			_spot_light.visible = _selected;


# Callbacks dos sinais:
# O mesmo callback é usado para o sinal do botão de confirmar e do botão de finalizar as
# trocas pois o funcionamento desejado é o mesmo: esconder qualquer spotlight que esteja acesa
# e desselecionar cada um dos corpos.
func _on_button_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout");
	_spot_light.hide();
	_selected = false;
	_spot_light.light_color = Color.white;


# Caso a troca seja rejeitada, muda a cor da spotlight para vermelho, para sinalizar
# que a troca é inválida
func _on_rejected_switch() -> void:
	_spot_light.light_color = Color.red;


# Permite que o jogador selecione esse corpo.
func _on_enable_body_area_visibility() -> void:
	_selectable_area.show();


# Não permite que o jogador selecione esse corpo.
func _on_disable_body_area_visibility() -> void:
	if(!_selected):
		_selectable_area.hide();

