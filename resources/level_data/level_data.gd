#######################################################
# Resource para guardar as informações de um nível
#######################################################

extends Resource

class_name LevelData

export(Enums.LevelType) var level_type; # Veja a documentação do singleton Enums para ver os tipos de niveis possíveis
export(int) var num_bodies; # Número de corpos que haverá no level (sem contar os corpos extra)
export(int) var num_extras; # Número de corpos extas que haverá no level
export(Array, Color) var colors; # Array com as cores de cada um dor corpos (deve ter tamanho num_bodies + num_extra)
export(Array, int) var initial_minds; # Array para determinar o estado inicial de cada uma das mentes
export(Array, Array, int) var initial_switches; # Array para determinar as trocas que ja foram reliazdas no início do level

# Veja o level1.tres para ver como utilizar cada um desses campos
