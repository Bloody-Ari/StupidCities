extends Tool
class_name SunflowerSeedsBag

var seeds_available = 0

func use(pos: Vector2, game_grid: GameGrid):
	if game_grid.grid[pos].plant_state == "Plowed" and seeds_available > 0:
		game_grid.grid[pos].plant_state = "Planted"
		game_grid.grid[pos].plant_type = "Sunflower"
		self.seeds_available -= 1
		game_grid.grid[pos].onChangedCell.emit(pos)
		game_grid.ChangedSeedAmount.emit(seeds_available)

func _init(_name, _descriptcion, _texture, _level, _quantity, _price):
	name = _name
	description = _descriptcion
	texture = _texture
	level = _level
	seeds_available = _quantity
	price = _price
