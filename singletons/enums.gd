extends Node

enum GameplayStates {
	MAIN_MENU,
	LEVEL,
	ANIMATING
}

enum MainMenuState {
	SELECTING,
	BOOKSHELF_SELECTED,
	BOOK_SELECTED,
	DOOR_SELECTED
}

enum LevelStates {
	SELECTING,
	SWITCHING,
	SOLVING
}

enum LevelType {
	LEVEL,
	SANDBOX
}
