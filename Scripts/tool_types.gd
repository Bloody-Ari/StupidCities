extends Resource
class_name Tool

var name: String
var texture: Texture
var description: String
var level: int
var price: int = 100

func _init(_name, _descriptcion, _texture, _level, _price):
	name = _name
	description = _descriptcion
	texture = _texture
	level = _level
	price = _price

func use(cords: Vector2, game_grid: GameGrid):
	print("Can I extend functions later???")
	pass
	
