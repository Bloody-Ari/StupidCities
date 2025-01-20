extends Resource
class_name MachineOnHand

var name
var texture

func _init(_name):
	name = _name
	match name:
		"aspersor_basico":
			texture = preload("res://art/Machines/AutoWaterer1.png")
		"water_tank":
			texture = preload("res://art/Machines/WaterTank.png")
		"pipe":
			texture = preload("res://art/Pipe.png")
		"valve":
			texture = preload("res://art/OpenPipeValve.png")
		"aspersor_a_presion":
			texture = preload("res://art/Machines/AutoWaterer2.png")
		"humidity_checker1":
			texture = preload("res://art/Waterer1Icon.png")
		"humidity_checker3":
			texture = preload("res://art/Waterer3Icon.png")

func use(pos: Vector2, game_grid: GameGrid):
	var player = game_grid.get_node("../Player")
	print("placing: ", name, " in position: ", pos)
	match name:
		"humidity_checker1":
			game_grid.grid[pos].humidity_checker_type = 1
			game_grid.grid[pos].humidity_label.visible = false
			game_grid.grid[pos].humidity_label.text = "Dirt humidity level: "
			game_grid.grid[pos].humidity_label.position = Vector2(pos.x*128, pos.y*128)
			game_grid.add_child(game_grid.grid[pos].humidity_label)
		"humidity_checker3":
			game_grid.grid[pos].humidity_checker_type = 3
			game_grid.humidity_network.append(pos)
			game_grid.grid[pos].humidity_label.visible = false
			game_grid.grid[pos].humidity_label.text = "Humidity level: "
			game_grid.grid[pos].humidity_label.position = Vector2(pos.x*128, pos.y*128)
			game_grid.add_child(game_grid.grid[pos].humidity_label)
		"aspersor_basico":
			game_grid.grid[pos].machine = Aspersor.new(
				"Aspersor Basico",
				"",
				load("res://art/Machines/AutoWaterer1.png"),
				1,
				"Water",
				"Pressure"
			)
			game_grid.grid[pos].machine.setup(pos, game_grid)
			game_grid.grid[pos].plant_state = "Cemento"
			game_grid.grid[pos].in_use = true
		"aspersor_a_presion":
			game_grid.grid[pos].machine = Aspersor.new(
				"Aspersor a presion",
				"",
				load("res://art/Machines/AutoWaterer1.png"),
				2,
				"Water",
				"Pressure"
			)
			game_grid.grid[pos].machine.setup(pos, game_grid)
			game_grid.grid[pos].plant_state = "Cemento"
			game_grid.grid[pos].in_use = true
		"water_tank":
			game_grid.grid[pos].machine = WaterTank.new(
				"Tanque de Agua",
				"",
				load("res://art/Machines/WaterTank.png"),
				1,
				"Water",
				"None",
				0
			)
			game_grid.grid[pos].plant_state = "Cemento"
			game_grid.grid[pos].in_use = true
		"pipe":
			game_grid.grid[pos].pipe_state = 0
			game_grid.grid[pos].pipe_label = Label.new()
			game_grid.grid[pos].pipe_label.text = "0"
			game_grid.grid[pos].pipe_label.position = Vector2(pos.x*128, pos.y*128)
			game_grid.add_child(game_grid.grid[pos].pipe_label)
			game_grid.pipes_grid.append(pos)
			print("New pipes grid: ", game_grid.pipes_grid)
			game_grid.pipes_grid.sort()
		"valve":
			game_grid.grid[pos].pipe_state = 0
			game_grid.grid[pos].valve_state = false
			game_grid.grid[pos].pipe_label = Label.new()
			game_grid.grid[pos].pipe_label.text = "0"
			game_grid.grid[pos].pipe_label.position = Vector2(pos.x*128, pos.y*128)
			game_grid.add_child(game_grid.grid[pos].pipe_label)
			game_grid.pipes_grid.append(pos)
			game_grid.pipes_grid.sort()
	game_grid.grid[pos].onChangedCell.emit(pos)
	player.remove_n_from_inventory(self, 1)
