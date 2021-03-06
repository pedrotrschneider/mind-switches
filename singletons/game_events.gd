extends Node

#------------------------------------
# GLOBAL SIGNALS
#------------------------------------
signal back_button_pressed;
signal show_back_button;
signal hide_back_button;

signal confirm_button_pressed;
signal hide_confirm_button;
signal show_confirm_button;

signal finish_switches_button_pressed;
signal hide_finish_switches_button;
signal show_finish_switches_button;

signal reset_minds_button_pressed;
signal hide_reset_minds_button;
signal show_reset_minds_button;

#------------------------------------
# MAIN MENU SIGNALS
#------------------------------------
signal bookshelf_selectd;

signal book_selected(z_global_pos);

signal door_selected;

signal go_to_level;

#------------------------------------
# GAME SIGNALS
#------------------------------------
signal body_selected(index);

#------------------------------------
# GLOBAL EMITTERS
#------------------------------------
func emit_back_button_pressed_signal() -> void:
	emit_signal("back_button_pressed");


func emit_show_back_button_signal() -> void:
	emit_signal("show_back_button");


func emit_hide_back_button_signal() -> void:
	emit_signal("hide_back_button");


func emit_confirm_button_pressed_signal() -> void:
	emit_signal("confirm_button_pressed");


func emit_hide_confirm_button_signal() -> void:
	emit_signal("hide_confirm_button");


func emit_show_confirm_button_signal() ->  void:
	emit_signal("show_confirm_button");


func emit_finish_switches_button_pressed_signal() -> void:
	emit_signal("finish_switches_button_pressed");


func emit_hide_finish_switches_button_signal() -> void:
	emit_signal("hide_finish_switches_button");

func emit_show_finish_switches_button_signal() -> void:
	emit_signal("show_finish_switches_button");


func emit_reset_minds_button_pressed_signal() -> void:
	emit_signal("reset_minds_button_pressed");


func emit_hide_reset_minds_button_signal() -> void:
	emit_signal("hide_reset_minds_button");


func emit_show_reset_minds_button_signal() -> void:
	emit_signal("show_reset_minds_button");

#------------------------------------
# MAIN MENU EMITTERS
#------------------------------------
func emit_bookshelf_selected_signal() -> void:
	emit_signal("bookshelf_selectd");


func emit_book_selected_signal(z_global_pos: float) -> void:
	emit_signal("book_selected", z_global_pos);


func emit_door_selected_signal() -> void:
	emit_signal("door_selected");


func emit_go_to_level_signal() -> void:
	emit_signal("go_to_level");

#------------------------------------
# GAME EMITTERS
#------------------------------------
func emit_body_selected_signal(index: int) -> void:
	emit_signal("body_selected", index);
