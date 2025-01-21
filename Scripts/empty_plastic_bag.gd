extends Tool
class_name EmptyPlasticBag

var quantity = 0

func use(pos: Vector2, game_grid: GameGrid):
	var player = game_grid.get_node("../Player")
	var seeds_index = 0
	for item in player.inventory:
		if item == ToolList.tool_list["sunflower_seeds_bag"]:
			break
		seeds_index+=1
	var seed_quantity = player.inventory[seeds_index].seeds_available
	if(seed_quantity >= 10):
		if(quantity <= 0):
			return
		# should add a 10 seed bag to the hotbar
		#lvl 1 is 10 seeds
		self.quantity -= 1
		var seed_bag = ToolList.tool_list["bolsa_de_pipas"]
		player.append_to_inventory(seed_bag)
		player.empty_plastic_bag_quantity.text = str(self.quantity)
		seed_quantity -= 10
		game_grid.ChangedSeedAmount.emit(seed_quantity)
		player.inventory[seeds_index].seeds_available = seed_quantity
	else:
		print("Please collect more seeds")

func _init(_name, _descriptcion, _texture, _level, _quantity, _price):
	name = _name
	description = _descriptcion
	texture = _texture
	level = _level
	quantity = _quantity
	price = _price
