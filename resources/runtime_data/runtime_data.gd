#######################################################
# Recurso para guardar informções compartilhadas do jogo, que podem ser usadas
# e alteradas por diversas cenas ao mesmo tempo, em tempo de execução
#######################################################

extends Resource

class_name RuntimeData

# Veja a documentação do singleton Enums para detalhes sobre cada um desses estados
export(Enums.GameplayStates) var current_gameplay_state; # Estado atual do jogo
export(Enums.MainMenuState) var current_main_menu_state; # Estado atual do menu principal
export(Enums.LevelStates) var current_level_state; # Estado atual do level

# runtime_data.tres é o recurso que pode ser passado para qualquer cena
# que for utilizar as informações presentes nele (veja a documentação de app.gd
# para um exemplo de como passar a runtime_data para uma cena)
