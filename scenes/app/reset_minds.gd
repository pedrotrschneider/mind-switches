extends Button

var _garbage;

func _ready():
	_garbage = GameEvents.connect("hide_reset_minds_button", self, "_on_hide_reset_minds_button");
	_garbage = GameEvents.connect("show_reset_minds_button", self, "_on_show_reset_minds_button");
	pass


func _on_ResetMinds_pressed() -> void:
	GameEvents.emit_reset_minds_button_pressed_signal();


func _on_hide_reset_minds_button() -> void:
	self.hide();


func _on_show_reset_minds_button() -> void:
	self.show();
