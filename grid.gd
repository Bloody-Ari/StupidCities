class_name GameGrid
extends TileMapLayer

@export var width: int = 24
@export var height: int = 24
@export var cell_size: int = 128
@export var debug: bool = false;

var seeds_display = Label.new()
var seeds = Label.new()
var monero_display = Label.new()
var monero = Label.new()

var cells_with_machines = []
signal ChangedMachineAmmount()

var plant_states = ["Plowed", "Planted", "FirstGrow", "SecondGrow", "ThirdGrow", "FullyGrown"]
@onready var plants_grid = $"../PlantsGrid"
@onready var pipes_texture_grid = $"../PipesGrid"
@onready var player = $"../Player"
@onready var aysa = $"../Area2D"
@onready var wire_layer = $"../WireLayer"
@onready var checkers_layer = $"../HumidityCheckersLayer"
var pipe_lock = false
var grid: Dictionary = {}
var pipes_grid = []
var drown_counter = 0
var pipes_timer = Timer.new()
var humidity_network = []

signal onCell(pos)
signal ChangedSeedAmount(new_value: int)
signal PickedUpSeeds(ammount: int)
signal ChangeMoneroAmount(new_value)
signal UsingCell(pos: Vector2)

func remove_pipe(pos):
	#print("About to remove pipe with locked state: ", pipe_lock)
	if grid[pos].pipe_state != null and !pipe_lock:
		if !grid[pos].aysa:
			pipe_lock = true
			#print("Removing pipe on cell: ", pos)
			player.append_to_inventory(MachineOnHand.new("pipe"))
			grid[pos].pipe_state = null
			grid[pos].valve_state = null
			pipes_grid.erase(pos)
			#print(pipes_grid)
			
			updateCellTile(pos)
			pipe_lock = false
	if grid[pos].humidity_checker_type != null:
		grid[pos].humidity_checker_type = null
		grid[pos].humidity_checker = null
		updateCellTile(pos)

func _onCell(pos):
	var position = Vector2(local_to_map(to_local(pos)).x, local_to_map(to_local(pos)).y)
	if grid[position].machine != null:
		if grid[position].machine.name == "Aspersor a presion":
			var timer = Timer.new()
			add_child(timer)
			timer.start(2)
			grid[position].machine.progress_bar.visible = true
			timer.timeout.connect(func():
				if grid[position].machine != null:
					grid[position].machine.progress_bar.visible = false
			)
	if grid[position].pipe_state != null:
		var timer = Timer.new()
		add_child(timer)
		timer.start(2)
		grid[position].pipe_label.visible = true		
		timer.timeout.connect(func():
			grid[position].pipe_label.visible = false
		)
	if grid[position].humidity_checker_type == 1:
		var timer = Timer.new()
		add_child(timer)
		timer.start(1)
		grid[position].humidity_label.text[-1] = str(int(grid[position].humidity))
		grid[position].humidity_label.visible = true
		timer.timeout.connect(func():
			grid[position].humidity_label.visible = false
		)

func generateGrid():
	for x in width:
		for y in height:
			grid[Vector2(x, y)] = CellData.new("PlainTerrain", Vector2(x,y))
			grid[Vector2(x, y)].onChangedCell.connect(_onCellUpdate)
			set_cell(Vector2(x, y), 0, Vector2(0, 0))
	aysa.setup()

func _onPipesTimer():
	var adjacent_cells
	var adjacent_machines
	if pipe_lock:
		return
	else:
		pipe_lock = true

	for cell in pipes_grid:
		pipe_lock = true
		adjacent_cells = []
		adjacent_machines = []
		if cell < Vector2(0, 0):
			continue
		if grid[cell].pipe_state <= 10:
			if Vector2(cell.x+1, cell.y) <= grid.keys()[-1]:
				if pipes_grid.has(Vector2(cell.x+1, cell.y)):
					adjacent_cells.append(Vector2(cell.x+1, cell.y))
				elif grid[Vector2(cell.x+1, cell.y)].machine != null:
					if grid[Vector2(cell.x+1, cell.y)].machine.name == "Tanque de Agua" or grid[Vector2(cell.x+1, cell.y)].machine.name == "Aspersor a presion":
						adjacent_machines.append(Vector2(cell.x+1, cell.y))
			if Vector2(cell.x, cell.y+1) <= grid.keys()[-1]:
				if pipes_grid.has(Vector2(cell.x, cell.y+1)):
					adjacent_cells.append(Vector2(cell.x, cell.y+1))
				elif grid[Vector2(cell.x, cell.y+1)].machine != null:
					if grid[Vector2(cell.x, cell.y+1)].machine.name == "Tanque de Agua" or grid[Vector2(cell.x, cell.y+1)].machine.name == "Aspersor a presion":
						adjacent_machines.append(Vector2(cell.x, cell.y+1))
			if cell.x > 0:
				if pipes_grid.has(Vector2(cell.x-1, cell.y)):
					adjacent_cells.append(Vector2(cell.x-1, cell.y))
				elif grid[Vector2(cell.x-1, cell.y)].machine != null:
					if grid[Vector2(cell.x-1, cell.y)].machine.name == "Tanque de Agua" or grid[Vector2(cell.x-1, cell.y)].machine.name == "Aspersor a presion":
						adjacent_machines.append(Vector2(cell.x-1, cell.y))
			if cell.y > 0:
				if pipes_grid.has(Vector2(cell.x, cell.y-1)):
					adjacent_cells.append(Vector2(cell.x, cell.y-1))
				elif grid[Vector2(cell.x, cell.y-1)].machine != null:
					if grid[Vector2(cell.x, cell.y-1)].machine.name == "Tanque de Agua" or grid[Vector2(cell.x, cell.y-1)].machine.name == "Aspersor a presion":
						adjacent_machines.append(Vector2(cell.x, cell.y-1))
		#while(grid[cell].pipe_state < 5 and adjacent_cells.size() > 0):
		for adjacent_cell in adjacent_cells:
			if grid[cell].pipe_state >= 2 and grid[adjacent_cell].pipe_state <= 7 and grid[cell].pipe_state > grid[adjacent_cell].pipe_state and  grid[cell].valve_state != false:
				grid[cell].pipe_state -= 2
				grid[cell].pipe_label.text[-1] = str(grid[cell].pipe_state)
				grid[adjacent_cell].pipe_state += 2
				grid[adjacent_cell].pipe_label.text[-1] = str(grid[adjacent_cell].pipe_state)
		for machine in adjacent_machines:
			if grid[machine].machine.name == "Aspersor a presion" and grid[cell].pipe_state >= 1 and grid[cell].valve_state != false:
				grid[cell].pipe_state -= 1
				grid[machine].machine.water_level += 2
			if grid[machine].machine.name == "Tanque de Agua":
				if machine.x > cell.x:
					if grid[cell].pipe_state > 3 and grid[machine].machine.water_level <= 98:
						grid[cell].pipe_state -= 1		
						grid[machine].machine.water_level += 2
				elif cell.x > machine.x and grid[cell].pipe_state <= 7:
					if grid[machine].machine.water_level > 0:
						grid[cell].pipe_state += 2
						grid[machine].machine.water_level -= 1
			grid[cell].pipe_label.text[-1] = str(grid[cell].pipe_state)
		#if(cell.pipes_grid)
	#print("Releasing pipe")
	pipe_lock = false


func onUsingCell(pos: Vector2):
	var position = local_to_map(to_local(pos))
	if grid[Vector2(position.x, position.y)].machine != null:
		grid[Vector2(position.x, position.y)].machine.interact.emit(position, self)
		_onCellUpdate(position)
	if grid[Vector2(position.x, position.y)].valve_state != null:
		grid[Vector2(position.x, position.y)].valve_state = !grid[Vector2(position.x, position.y)].valve_state 
		_onCellUpdate(position)
	if player.left_click_tool != null:
		if player.left_click_tool.name == "Check" or player.left_click_tool.name == "humidity_checker3remote" or debug:
			player.left_click_tool.use(position, self)
	if player.right_click_tool != null:
		if player.right_click_tool.name == "Check" or player.right_click_tool.name == "humidity_checker3remote" or debug:
			player.right_click_tool.use(position, self)

func _onPickedUpSeeds(ammount: int):
	var seeds_index = 0
	for item in player.inventory:
		if item == ToolList.tool_list["sunflower_seeds_bag"]:
			break
		seeds_index+=1
	player.inventory[seeds_index].seeds_available += ammount
	ChangedSeedAmount.emit(player.inventory[seeds_index].seeds_available)

func _onChangedSeedAmount(new_value: int):
	#update inventory 
	self.seeds_display.text = str(new_value)
	player.seeds_bag_quantity.text = str(new_value)

func _onChangedMoneroAmount(new_value):
	self.monero_display.text = str(new_value)

func _ready() -> void:
	seeds.text = str("Seeds in your inventory: ")
	seeds.position = Vector2(-560, -300)
	seeds_display.text = str(player.inventory[3].seeds_available)
	seeds_display.position = Vector2(-350, -300)

	monero.text = str("  in your wallet: ")
	monero.position = Vector2(-560, -250)
	monero_display.text = str(player.money)
	monero_display.position = Vector2(-350, -250)

	seeds.z_index = 4
	monero.z_index = 4
	seeds_display.z_index = 4
	monero_display.z_index = 4
	#player.add_child(seeds)
	player.add_child(monero)
	#player.add_child(seeds_display)
	player.add_child(monero_display)

	ChangedSeedAmount.connect(_onChangedSeedAmount)
	PickedUpSeeds.connect(_onPickedUpSeeds)
	ChangeMoneroAmount.connect(_onChangedMoneroAmount)
	UsingCell.connect(onUsingCell)
	onCell.connect(_onCell)
	pipes_timer.timeout.connect(_onPipesTimer)
	add_child(pipes_timer)
	pipes_timer.start(1)
'''
	wire_layer.wired_tiles.append(Vector2(0,0))
	wire_layer.wired_tiles.append(Vector2(0,1))
	wire_layer.wired_tiles.append(Vector2(0,2))
	wire_layer.wired_tiles.append(Vector2(0,3))
	wire_layer.wired_tiles.append(Vector2(1, 0))
	wire_layer.wired_tiles.append(Vector2(1, 1))
'''	
	# Te hacercas, te spawnea la lista y podes seleccionar el nivel, sea 0, 1 o 2
	# se te cobra cuando elegis y, si tenes la plata, cada vez que corre el timer

func _onCellUpdate(_pos: Vector2):
	var cell = grid[_pos]
	if grid[_pos].humidity <= 3:
		grid[_pos].state = "DryDirt"
	if grid[_pos].humidity > 3 and grid[_pos].humidity <= 6: #and grid[_pos].state == "WetDirt":
		grid[_pos].state = "PlainDirt"
	if grid[_pos].humidity > 6 and grid[_pos].state == "PlainDirt":
		grid[_pos].state = "WetDirt"

	if grid[_pos].humidity > 10 and grid[_pos].state != "TooWetDirt":
		grid[_pos].state = "TooWetDirt"
		grid[_pos].onChangedCell.emit(_pos)

	if grid[_pos].humidity > 3 and grid[_pos].state == "PlainDirt" and grid[_pos].plant_state == "None":
		var standard_terrain_timer = Timer.new()
		self.add_child(standard_terrain_timer)
		standard_terrain_timer.start(10)
		standard_terrain_timer.one_shot = true
		standard_terrain_timer.timeout.connect(func():
			if grid[_pos].humidity > 5 and grid[_pos].state == "PlainDirt" and grid[_pos].plant_state == "None":
				grid[_pos].state = "PlainTerrain"
				grid[_pos].onChangedCell.emit(_pos)
		)
	if cell.plant_state == "Planted":
		add_child(cell.timer)
		cell.timer.start(1)
		cell.counter = 0
		
		cell.timer.one_shot = false
		cell.plant_state = "Seed"
		#cell.onChangedCell.emit(_pos)
		cell.timer.timeout.connect(func():
		#if cell.state !="DryDirt":
			if cell.humidity >= 6 and cell.humidity <= 10:
				cell.counter += 1
			else:
				if cell.state == "TooWetDirt":
					drown_counter += 1
					if drown_counter >= 3:
						cell.plant_state = "DrownedPlant"

			match cell.plant_state:
				"Seed":
					if cell.counter >= cell.first_grow_time and cell.counter < cell.second_grow_time:
						cell.plant_state = "FirstGrow"
						cell.onChangedCell.emit(_pos)
				"FirstGrow":
					if cell.counter >= cell.second_grow_time and cell.counter < cell.third_grow_time:
						cell.plant_state = "SecondGrow"
						cell.onChangedCell.emit(_pos)
				"SecondGrow":
					if cell.counter >= cell.third_grow_time and cell.counter <cell.fully_grown_time:
						cell.plant_state = "ThirdGrow"
						cell.onChangedCell.emit(_pos)
				"ThirdGrow":
					if cell.counter >= cell.fully_grown_time:
						cell.plant_state = "FullyGrown"
						cell.onChangedCell.emit(_pos)
						#cell.timer.stop()
						remove_child(cell.timer)
				"DrownedPlant":
					cell.onChangedCell.emit(_pos)
					remove_child(cell.timer)
	)
	updateCellTile(_pos)

"""
var first_grow_time = 1
var second_grow_time = 2
var third_grow_time = 4
var fully_grown_time = 6
"""
func updateCellTile(pos:Vector2):
	var cell = grid[pos]
	var new_tile: Vector2 = Vector2(-1, -1)
	var new_plant_tile: Vector2 = Vector2(-1, -1)
	var new_machine_tile: Vector2 = Vector2(-1, -1)
	var new_pipe_tile: Vector2 = Vector2(-1, -1)
	var new_humidity_checker_tile = Vector2(-1, -1)
	match cell.state:
		"DryDirt":
			new_tile = Vector2(2, 0)
		"PlainDirt":
			new_tile = Vector2(1, 0)
		"PlainTerrain":
			new_tile = Vector2(0, 0)
		"WetDirt":
			new_tile = Vector2(3, 0)
		"TooWetDirt":
			new_tile = Vector2(7, 1)
	match cell.plant_state:
		"None":
			new_plant_tile = Vector2(5, 0)
		"Plowed":
			if cell.state == "DryDirt":
				new_plant_tile = Vector2(4, 0)
			else:
				new_plant_tile = Vector2(1, 1)
		"Seed":
			new_plant_tile = Vector2(0, 1)
		"FirstGrow":
			new_plant_tile = Vector2(2, 1)
		"SecondGrow":
			new_plant_tile = Vector2(3, 1)
		"ThirdGrow":
			new_plant_tile = Vector2(4, 1)
		"FullyGrown":
			new_plant_tile = Vector2(5, 1)
		"DrownedPlant":
			new_plant_tile = Vector2(9, 1)

# NO puede haber maquina y ca;o al mismo tiempo
	if(cell.machine != null):
		match cell.machine.name:
			"Aspersor Basico":
				if cell.machine.powered_on:
					new_machine_tile = Vector2(7, 0)
				else:
					new_machine_tile = Vector2(6, 0)
			"Tanque de Agua":
				new_machine_tile = Vector2(6, 1)
			"Aspersor a presion":
				new_machine_tile = Vector2(2, 2)
	
	if cell.humidity_checker_type != null:
		match cell.humidity_checker_type:
			1:
				new_humidity_checker_tile = Vector2(0, 3)
			3:
				new_humidity_checker_tile = Vector2(9, 2)
	else:
		new_humidity_checker_tile = Vector2(5, 0)

	if pos == Vector2(0,0):
		new_pipe_tile = Vector2(3,2)
	else:
		if cell.valve_state != null:
			if cell.valve_state:
				new_pipe_tile = Vector2(1, 2)
			else:
				new_pipe_tile = Vector2(0, 2)
		elif cell.pipe_state != null:
			new_pipe_tile = Vector2(9, 0)
		else:
			new_pipe_tile = Vector2(5, 0)

	if(new_tile > Vector2(-1, -1)):
		set_cell(pos, 0, new_tile)
	if(new_machine_tile > Vector2(-1, -1)):
		plants_grid.set_cell(pos, 1, new_machine_tile)
	if(new_plant_tile > Vector2(-1, -1)):
		plants_grid.set_cell(pos, 2, new_plant_tile)
	if(new_pipe_tile > Vector2(-1, -1)):
		pipes_texture_grid.set_cell(pos, 0, new_pipe_tile)
	if(new_humidity_checker_tile > Vector2(-1,-1)):
		checkers_layer.set_cell(pos, 0, new_humidity_checker_tile)


func _onHumidityTimer():
	for cell in grid:
		if !grid[cell].in_use:
			continue
		if grid[cell].humidity >= 1:
			grid[cell].humidity -= 0.5
			grid[cell].onChangedCell.emit(cell)

func _onChangedMachineAmmount():
	print("Changed ammount of machines on the map")

#AYSA
# Deberia ser una pipe o la linea en la izquierda que tiene cierta cantdiad que se refilea cada x tiempo,
# se consume 1 se agrega 1, o sea se mantienen en 9 las tuverias hasta que te gastas el total del agua
