extends Tool
class_name Bucket

var water_level = 0

func use(pos: Vector2, game_grid: GameGrid):
	print("Using bucket on cell: ", pos)
	var player = game_grid.get_node("../Player")
	if game_grid.grid[pos].machine != null:
		var machine = game_grid.grid[pos].machine
		print("With machine: ", machine.name)
		match machine.name:
			"Tanque de Agua":
				print("Llenando balde")
				if machine.water_level >= 5 and water_level < 5:
					machine.water_level -= 5
					water_level += 5
					player.bucket_level_label.text[-1] = str(water_level)
			"Aspersor Basico":
				print("Llenando aspersor")
				if machine.water_level < 20:
					machine.water_level += 5
					water_level -= 5
					player.bucket_level_label.text[-1] = str(water_level)

func _init(_name, _descriptcion, _texture, _level, _price):
	name = _name
	description = _descriptcion
	texture = _texture
	level = _level
	price = _price


	# get what is in selected cell
	# if has any water thing 
	# check for 
