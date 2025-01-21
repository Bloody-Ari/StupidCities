extends Tool
class_name OnHandHumidityChecker

func use(pos: Vector2, game_grid: GameGrid):
	var player = game_grid.get_node("../Player")
	player.humidity_label.text = str("Humidity level on cell: ", pos, " = ", game_grid.grid[pos].humidity)
	player.humidity_label.visible = !player.humidity_label.visible

func _init(_name, _descriptcion, _texture, _level, _price):
	name = _name
	description = _descriptcion
	texture = _texture
	level = _level
	price = _price
