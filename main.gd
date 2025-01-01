extends Node

@onready var game_grid : GameGrid = $Grid
@onready var player : Area2D = $Player

# Una clase que sea Celda
# Un diccionario tiene la tabla de celdas
# tiene que tener:
# posicion
# estado

# 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_grid.generateGrid(
	)


func _process(delta: float) -> void:
	#game_grid.update_grid()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

		#print("Which is tile: ", background_map.local_to_map(background_map.get_local_mouse_position()))
	# if has gloves in hand or whatever

	#background_map.set_cell()
