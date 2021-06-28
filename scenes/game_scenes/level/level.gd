#######################################################
# Script que controla o funcionamento de qualquer level
#######################################################

extends Spatial

var _garbage;

# Variáveis do editor:
export(Resource) onready var _runtime_data = _runtime_data as RuntimeData; # Veja a documentação do recurso RuntimeData para mais detalhes soobre o que é isso.
export(NodePath) onready var _center_position = get_node(_center_position) as Position3D; # Referência para a posição de centro do campo.
export(Array, NodePath) var _extra_positions_paths; # Array com as posições dos corpos extras.
export(NodePath) onready var _vertical_box = get_node(_vertical_box) as VBoxContainer; # Referência à caixa vertical que contém a informação sobre as trocas ja realizadas.
export(NodePath) onready var _camera = get_node(_camera) as Camera; # Referência à camera do jogo.

onready var _swtich_ui_res = preload("res://scenes/game_scenes/switch_ui/switch_ui.tscn"); # Referência para a cena de interface das trocas. Cada par de quadradinhos é uma cena dessas.

var level_data : LevelData; # Referência para o recurso de informações do nível.
onready var _body_scene_res : Resource = preload("res://scenes/game_scenes/body/body.tscn"); # Referência para a cena do corpo.
var _num_bodies: int;  # Número de corpos.
var _colors : Array = []; # Array das cores dos corpos.
var _bodies : Array = []; # Array das posições dos corpos (representados por indices de 0 a (num_bodies + num_extras - 1).
var _minds : Array = []; # Array das posições das mentes (representados pelos mesmos indices do array das posições dos corpos).
var _switches_buffer : Array = []; # Array que guarda todas as trocas que foram realizadas ate o momento.
var _selected_bodies : Array = []; # Array que guarda os índices dos corpos que estão selecionados no momento.
var _minds_solving_init_config : Array = []; # Array que guarda a configuração das mentes no momento em que foi inciada a fase de resolução (serve para o sistema de resetar as mentes e tentar de novo)
var _switches_buffer_solving_init_config : Array = []; # Array que guarda as trocas que foram realizadas no momento em que foi inciada a fase de resolução (serve para ao sistema de resetar as mentes e tentar de novo)

func _ready() -> void:
	GameEvents.emit_fade_in_signal(0.6); # Começa com uma animação de fade in de 0.6 seg
	
	# Conecta aos sinais relevantes (veja a documentação do singleton GameEvents para mais informações sobre os sinais)
	_garbage = GameEvents.connect("body_selected", self, "_on_body_selected");
	_garbage = GameEvents.connect("confirm_button_pressed", self, "_on_confirm_button_pressed")
	_garbage = GameEvents.connect("finish_switches_button_pressed", self, "_on_finish_switches_button_pressed");
	_garbage = GameEvents.connect("reset_minds_button_pressed", self, "_on_reset_minds_button_pressed");
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	
	GameEvents.emit_show_back_button_signal(); # Mostra o botão de voltar
	
	_num_bodies = level_data.num_bodies; # Extrai o número de corpos da level_data
	_colors = level_data.colors; # Extrai o array de cores da level_data
	
	_bodies.resize(_num_bodies + level_data.num_extras); # Cria o array de corpos com o tamanho certo
	_minds.resize(_num_bodies + level_data.num_extras); # Cria o array de mentes com o tamanho certo
	
	_minds = level_data.initial_minds; # Extrai a configuração inicial das mentes do level_data
	# Popula o array de corpos com os índices em ordem crescente
	for b in (_num_bodies + level_data.num_extras):
		_bodies[b] = b;
	_switches_buffer = level_data.initial_switches; # extrai as trocas que já foram feitas da level_data
	
	# Popula o array das posições dos corpos extras baeado em quantos corpos extra o level pediu.
	var _extra_positions = [0, 0];
	for pos_i in _extra_positions_paths.size():
		_extra_positions[pos_i] = get_node(_extra_positions_paths[pos_i]) as Position3D;
	
	############################################################################
	# Esse bloco de código serve para gerar as posições no círculo em que serão
	# Dispostos os corpos. O raio r do círculo varia dependendo do número de
	# corpos poedido pelo nível, e a distância angular entre eles será sempre
	# 360° / num_bodies.
	# Usamos um sistema de coordenadas polares para calcular as posições, com
	# centro na posição central do mapa (_center_position), e depois convertemos
	# para coordenadas cartesianas.
	# Basciamente, um monte de fórmulas e contas para converter de coordenadas
	# polares para cartesianas. Se tiverem dpuvidas na matemática podem falar,
	# mas o mais importante aqui é a seleção do raio, da posição da camera e do
	# offset nas posições dos corpos extra com base no número de corpos que o nível
	# pede. Todos esses valores foram obtidos com tentativa e erro de valores
	# diferentes, com mais tentativa e erro, podem ser ajustado para valores
	# melhores.
	
	# Essa parte escolhe o raio, posição da câmera e offset das posições dos corpos
	# extra com base no número de corpos que o nível pediu.
	
	var r : float;
	if(_num_bodies == 1):
		r = 0;
		
		var camera_pos: Vector3 = Vector3(10.471, 9.458, 0);
		var _camera_rot: Vector3 = Vector3(-55.42, 90, 0);
		_camera.global_transform.origin = camera_pos;
		_camera.rotation_degrees = _camera_rot;
		
		_extra_positions[0].global_transform.origin.x += 0;
		_extra_positions[1].global_transform.origin.x += 0;
		
	elif(_num_bodies <= 5):
		r = 3;
		
		var camera_pos: Vector3 = Vector3(10.471, 9.458, 0);
		var _camera_rot: Vector3 = Vector3(-55.42, 90, 0);
		_camera.global_transform.origin = camera_pos;
		_camera.rotation_degrees = _camera_rot;
		
		_extra_positions[0].global_transform.origin.x += 0;
		_extra_positions[1].global_transform.origin.x += 0;
		
	elif(_num_bodies <= 10):
		r = 5;
		
		var camera_pos: Vector3 = Vector3(10.471, 9.458, 0);
		var _camera_rot: Vector3 = Vector3(-55.42, 90, 0);
		_camera.global_transform.origin = camera_pos;
		_camera.rotation_degrees = _camera_rot;
		
		_extra_positions[0].global_transform.origin.x += 0;
		_extra_positions[1].global_transform.origin.x += 0;
		
	elif(_num_bodies <= 14):
		r = 7;
		
		var camera_pos: Vector3 = Vector3(10.471, 9.458, 0);
		var _camera_rot: Vector3 = Vector3(-55.42, 90, 0);
		_camera.global_transform.origin = camera_pos;
		_camera.rotation_degrees = _camera_rot;
		
		_extra_positions[0].global_transform.origin.x += 0;
		_extra_positions[1].global_transform.origin.x += 0;
		
	elif(_num_bodies <= 17):
		r = 9;
		
		var camera_pos: Vector3 = Vector3(17.385, 10.292, 0);
		var _camera_rot: Vector3 = Vector3(-34.90, 90, 0);
		_camera.global_transform.origin = camera_pos;
		_camera.rotation_degrees = _camera_rot;
		
		_extra_positions[0].global_transform.origin.x += 3;
		_extra_positions[1].global_transform.origin.x += 3;
		
	elif(_num_bodies > 17):
		r = 11;
		
		var camera_pos: Vector3 = Vector3(17.385, 10.292, 0);
		var _camera_rot: Vector3 = Vector3(-34.90, 90, 0);
		_camera.global_transform.origin = camera_pos;
		_camera.rotation_degrees = _camera_rot;
		
		_extra_positions[0].global_transform.origin.x += 4;
		_extra_positions[1].global_transform.origin.x += 4;
		
	
	# Essa parte calcula a separação angular entre os corpos e converte as coordenadas
	# polares para as corrdenadas cartesianas, para nos das as posições de cada
	# um dos corpos presentes no círculo.
	# Já é responsável por adicionar na cena os corpos no círuclo também.
	var sep : float = 360.0 / float(_num_bodies);
	var a : float = 0;
	for b in _num_bodies:
		var posX: float = _center_position.global_transform.origin.x + r * cos(deg2rad(a));
		var posZ: float = _center_position.global_transform.origin.z + r * sin(deg2rad(a));
		
		var body_instance = _body_scene_res.instance();
		self.add_child(body_instance);
		body_instance.global_transform.origin = Vector3(posX, 0, posZ);
		body_instance.index = b;
		body_instance.mind_color = _colors[_minds[b]];
		body_instance.body_color = _colors[b];
		
		a += sep;
		
	
	# Adiciona os corpos extras na cena nas posições que foram calculadas para eles
	for e in level_data.num_extras:
		var body_instance = _body_scene_res.instance();
		self.add_child(body_instance);
		body_instance.global_transform.origin = _extra_positions[e].global_transform.origin;
		body_instance.index = _num_bodies + e;
		body_instance.mind_color = _colors[_minds[_num_bodies + e]];
		body_instance.body_color = _colors[_num_bodies + e];
		body_instance.hide();
		
	# Aqui termina o bloco de código destinado ao cálculo das posições dos corpos
	# no círculo central.
	############################################################################
	
	# Adiciona as trocas ja realizadas no começo do nível à UI de trocas
	for s in _switches_buffer.size():
		if(s % 2 == 0): # Como as trocas vem repetidas ([a, b] e [b, a]) ignoramos uma a cada duas trocas
			continue;
		
		_add_switches_ui(_colors[_switches_buffer[s][0]], _colors[_switches_buffer[s][1]]);
	
	if(level_data.level_type == Enums.LevelType.LEVEL): # Caso o nível nao seja sandbox, pula direto para a parte de resolução.
		_on_finish_switches_button_pressed();
	
	_vertical_box.show(); # Mostra a box vertical que contém as trocas que ja foram realizadas.


# Função responsável por realizar as trocas
func switch() -> void:
	if(!_switches_buffer.has(_selected_bodies)): # Checa se a troca já foi realizada.
		# Adiciona as trocas no array de trocas (tanto a troca escolhida quanto a sua simétrica).
		_switches_buffer.append([_selected_bodies[0], _selected_bodies[1]]);
		_switches_buffer.append([_selected_bodies[1], _selected_bodies[0]]);
		
		# Troca de fato as mentes no array de mentes.
		var aux: int = _minds[_selected_bodies[0]];
		_minds[_selected_bodies[0]] = _minds[_selected_bodies[1]];
		_minds[_selected_bodies[1]] = aux;
		
		# Atualiza as cores das mentes dos corpos envolvidos na troca.
		var bodies = get_tree().get_nodes_in_group("Body");
		var mind1 = _minds[_selected_bodies[0]];
		var mind2 = _minds[_selected_bodies[1]];
		for body in bodies:
			if(body.index == _selected_bodies[0]):
				body.mind_color = _colors[mind1];
			elif(body.index == _selected_bodies[1]):
				body.mind_color = _colors[mind2];
		
		# Prints para debug
		print(_minds);
		print(_switches_buffer);
		
		_add_switches_ui(_colors[_selected_bodies[0]], _colors[_selected_bodies[1]]); # Adiciona a troca realizada na interface de trocas.
		
	else: # Caso já tenha sido realizada, emite o sinal de troca rejeitada.
		print("troca rejeitada");
		GameEvents.emit_rejected_switch_signal();
	
	_selected_bodies.clear(); # Limpa a lista de trocas realizadas.
	_runtime_data.current_level_state = Enums.LevelStates.SELECTING; # Muda o estado de gameplay de volta para selecionando.
	GameEvents.emit_hide_confirm_button_signal(); # Esconde o botão de confirmar a troca (ele so aparece quando tem dois corpos selecionados)
	
	if(_switches_buffer.size() > 1): # Caso pelo menos uma troca ja tenha sido realizada
		GameEvents.emit_show_finish_switches_button_signal(); # Mosta o botão de finalizar as trocas


# Função responsável por adicionar as trocas na interface de trocas.
# Recebe duas cores, que serão as cores de cada um dos quadrados novos adicionados.
func _add_switches_ui(col1 : Color, col2 : Color) -> void:
	var switch_ui_instance = _swtich_ui_res.instance(); # Cria uma nova instancia dos quadradinhos que representam as trocas.
	switch_ui_instance.set_colors(col1, col2); # Seta as cores dos quadrados.
	
	_vertical_box.add_child(switch_ui_instance); # Adiciona os quadrados na caixa vertical.


# Callbacks dos sinais:
# Responsável por lidar com a seleção dos corpos pelo jogador.
func _on_body_selected(index : int) -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
		if(!_selected_bodies.has(index)):
			if(_selected_bodies.size() < 2):
				_selected_bodies.append(index);
		else:
			GameEvents.emit_enable_body_area_visibility_signal();
			_selected_bodies.remove(_selected_bodies.find(index));
			GameEvents.emit_hide_confirm_button_signal();
		
		if(_selected_bodies.size() == 2):
			GameEvents.emit_disable_body_area_visibility_signal();
			GameEvents.emit_show_confirm_button_signal();
		
		print(_selected_bodies);


# Responsável por lidar com o clique no botão de confirmar a troca.
func _on_confirm_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
			_runtime_data.current_level_state = Enums.LevelStates.SWITCHING;
			switch();
			GameEvents.emit_enable_body_area_visibility_signal();


# Responsável por lidar com o clique no botão de finanlizar as trocas.
func _on_finish_switches_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.LEVEL\
		&& _runtime_data.current_level_state == Enums.LevelStates.SELECTING):
			_selected_bodies.clear();
			GameEvents.emit_hide_finish_switches_button_signal();
			GameEvents.emit_show_reset_minds_button_signal();
			_minds_solving_init_config = _minds.duplicate();
			_switches_buffer_solving_init_config = _switches_buffer.duplicate();
			var bodies = get_tree().get_nodes_in_group("Body");
			for body in bodies:
				body.show();


# Responsável por lidar com o clique no botão de resetar as mentes na etapa de soluçaão.
func _on_reset_minds_button_pressed() -> void:
	GameEvents.emit_hide_confirm_button_signal();
	GameEvents.emit_enable_body_area_visibility_signal();
	print(_minds_solving_init_config);
	var bodies = get_tree().get_nodes_in_group("Body");
	var i: int = 0;
	for body in bodies:
		body.mind_color = _colors[_minds_solving_init_config[i]];
		i += 1;
	
	_minds = _minds_solving_init_config.duplicate();
	
	var switches_ui = _vertical_box.get_children();
	var dif = _switches_buffer.size() - _switches_buffer_solving_init_config.size();
	for j in dif / 2:
		switches_ui[_switches_buffer_solving_init_config.size() / 2.0 + j].queue_free();
	
	_switches_buffer = _switches_buffer_solving_init_config.duplicate();


# Responsável por lidar com o clique no botão de voltar.
func _on_back_button_pressed() -> void:
	GameEvents.emit_hide_back_button_signal();
	GameEvents.emit_hide_confirm_button_signal();
	GameEvents.emit_hide_finish_switches_button_signal();
	GameEvents.emit_hide_reset_minds_button_signal();
	_vertical_box.hide();
	GameEvents.emit_fade_out_signal(0.6);
	yield(get_tree().create_timer(0.6), "timeout");
	if(level_data.level_type == Enums.LevelType.SANDBOX):
		GameEvents.emit_go_to_sandbox_creator_signal();
	elif(level_data.level_type == Enums.LevelType.LEVEL):
		GameEvents.emit_go_to_level_loader_signal();
