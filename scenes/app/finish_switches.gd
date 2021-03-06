extends Button

var _garbage;

func _ready():
	_garbage = GameEvents.connect("hide_finish_switches_button", self, "_on_hide_finish_switches_button");
	_garbage = GameEvents.connect("show_finish_switches_button", self,  "_on_show_finish_switches_button");


func _on_FinishSwitches_pressed():
	GameEvents.emit_finish_switches_button_pressed_signal();


func _on_hide_finish_switches_button() -> void:
	self.hide();


func _on_show_finish_switches_button() -> void:
	self.show();
