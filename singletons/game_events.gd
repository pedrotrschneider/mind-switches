extends Node

signal back_button_pressed;
signal show_back_button;
signal hide_back_button;

signal bookshelf_selectd;

signal book_selected;

func emit_back_button_pressed_signal() -> void:
	emit_signal("back_button_pressed");


func emit_show_back_button_signal() -> void:
	emit_signal("show_back_button");


func emit_hide_back_button_signal() -> void:
	emit_signal("hide_back_button");


func emit_bookshelf_selected_signal() -> void:
	emit_signal("bookshelf_selectd");


func emit_book_selected_signal() -> void:
	emit_signal("book_selected");
