extends TileMapLayer

var conections = []

var wired_tiles = []
# Called when the node enters the scene tree for the first time.

func add_cell(position):
	print("Chagned cells")
	if conections.size() > 0:
		for conection in conections:
			print(conection)
	else:
		conections.append(position)

	#set_cells_terrain_path(wired_tiles, 0,0)
	set_cells_terrain_connect(wired_tiles, 0, 0)
	
func _ready() -> void:
	add_cell({"value": true, "position": Vector2(0,0)})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
