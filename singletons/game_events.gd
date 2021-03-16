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

signal fade_in(duration);
signal fade_out(duration);

#------------------------------------
# MAIN MENU SIGNALS
#------------------------------------
signal bookshelf_selectd;

signal book_selected(z_global_pos);

signal door_selected;
signal open_door;
signal close_door;

signal game_type_level_selected;
signal game_type_sandbox_selected;

#------------------------------------
# GAME SIGNALS
#------------------------------------
signal go_to_level(level_data);

signal go_to_sandbox_creator;
signal go_to_level_loader;

signal body_selected(index);
signal enable_body_area_visibility;
signal disable_body_area_visibility;

signal rejected_switch;

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


func emit_fade_in_signal(duration: float):
	emit_signal("fade_in", duration);


func emit_fade_out_signal(duration: float):
	emit_signal("fade_out", duration);

#------------------------------------
# MAIN MENU EMITTERS
#------------------------------------
func emit_bookshelf_selected_signal() -> void:
	emit_signal("bookshelf_selectd");


func emit_book_selected_signal(z_global_pos: float) -> void:
	emit_signal("book_selected", z_global_pos);


func emit_door_selected_signal() -> void:
	emit_signal("door_selected");


func emit_open_door_signal() -> void:
	emit_signal("open_door");


func emit_close_door_signal() -> void:
	emit_signal("close_door");


func emit_game_type_level_selected_signal() -> void:
	emit_signal("game_type_level_selected");


func emit_game_type_sandbox_selected_signal() -> void:
	emit_signal("game_type_sandbox_selected");

#------------------------------------
# GAME EMITTERS
#------------------------------------
func emit_go_to_level_signal(level_data: LevelData) -> void:
	emit_signal("go_to_level", level_data);


func emit_go_to_sandbox_creator_signal() -> void:
	emit_signal("go_to_sandbox_creator");


func emit_go_to_level_loader_signal() -> void:
	emit_signal("go_to_level_loader");


func emit_body_selected_signal(index: int) -> void:
	emit_signal("body_selected", index);


func emit_rejected_switch_signal() -> void:
	emit_signal("rejected_switch");


func emit_enable_body_area_visibility_signal() -> void:
	emit_signal("enable_body_area_visibility");


func emit_disable_body_area_visibility_signal() -> void:
	emit_signal("disable_body_area_visibility");
