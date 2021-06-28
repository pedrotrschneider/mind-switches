#######################################################
# Singleton para guardar diversos Enums.
# Geralmente é usado para guardas diversos estados do jogo, mas pode ser
# usado em qualquer outra aplicação que seja relevante.
#######################################################

extends Node

# Estados de gameplay: Se referem a qual parte do jogo estamos no momento
enum GameplayStates {
	MAIN_MENU, # Se estamos no menu principal
	LEVEL, # Se estamos no level
	ANIMATING # Se estamos no meio de uma animação (ex: A animação do menu principal da camera passando pela porta)
}

# Estados do menu principal: Se refere a qual parte do menu principal estamos no momento
enum MainMenuState {
	SELECTING, # Se estamos na primeira partes, selecionando entre a prateleira de livros e a porta
	BOOKSHELF_SELECTED, # Se tivermos selecionado a prateleira de livros
	BOOK_SELECTED, # Se, dentro da prateleira de livros, selecionarmos um livro
	DOOR_SELECTED, # Se selecionarmos a porta
	SELECTING_LEVEL_TYPE # Equanto estivermos selecionanndo o tipo de nível (sala com a maquina em que podemos clicar em um dos capacetes)
}

# Estados internos ao gamplay de um nível
enum LevelStates {
	SELECTING, # Enquanto estamos selecionando corpos para trocar
	SWITCHING, # Enquanto estamos no meio da animação de trocar os corpos
	SOLVING # Enquanto estivermos na parte de resolver
}

# Tipo diferentes de nível que podem haver
enum LevelType {
	LEVEL, # Se for um nível pre selecioando
	SANDBOX # Se for um nível criado pelo jogador na parte de sandbox
}
