extends Spatial

var _garbage;

export(Resource) onready var _runtime_data = _runtime_data as RuntimeData;
export(NodePath) onready var _camera_animation_player = get_node(_camera_animation_player) as AnimationPlayer;


func _ready() -> void:
	_garbage = GameEvents.connect("back_button_pressed", self, "_on_back_button_pressed");
	_garbage = GameEvents.connect("bookshelf_selectd", self, "_on_bookshelf_selectd");
	_garbage = GameEvents.connect("book_selected", self, "_on_book_selected");


func _on_back_button_pressed() -> void:
	if(_runtime_data.current_gameplay_state == Enums.GameplayStates.ANIMATING):
		if(_runtime_data.current_main_menu_state == Enums.MainMenuState.BOOKSHELF_SELECTED):
			_camera_animation_player.play_backwards("SelectedShelf");
		elif(_runtime_data.current_main_menu_state == Enums.MainMenuState.BOOK_SELECTED):
			_camera_animation_player.play_backwards("BookSelected");


func _on_bookshelf_selectd() -> void:
	_camera_animation_player.play("SelectedShelf");


func _on_book_selected() -> void:
	_camera_animation_player.play("BookSelected");
