extends Button

var _garbage;

func _ready():
	_garbage = GameEvents.connect("hide_confirm_button", self, "_on_hide_confirm_button");
	_garbage = GameEvents.connect("show_confirm_button", self, "_on_show_confirm_button");
	pass


func _on_ConfirmButton_pressed():
	GameEvents.emit_confirm_button_pressed_signal();


func _on_hide_confirm_button() -> void:
	self.hide();


func _on_show_confirm_button() -> void:
	self.show();
