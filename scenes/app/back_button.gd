extends Button

var _garbage;

func _ready() -> void:
	_garbage = GameEvents.connect("show_back_button", self, "_on_show_back_button");
	_garbage = GameEvents.connect("hide_back_button", self, "_on_hide_back_button");


func _on_BackButton_pressed() -> void:
	GameEvents.emit_back_button_pressed_signal();


func _on_show_back_button() -> void:
	self.show();


func _on_hide_back_button() -> void:
	self.hide();
