extends Spatial

export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer;

func _ready():
	_animation_player.play("OscilatingLight", -1, 0.3);
