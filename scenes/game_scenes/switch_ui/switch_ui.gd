extends Control

export(NodePath) onready var _rect1 = get_node(_rect1) as ColorRect;
export(NodePath) onready var _rect2 = get_node(_rect2) as ColorRect;

var col1: Color;
var col2: Color;


func _ready():
	_rect1.color = col1;
	_rect2.color = col2;
