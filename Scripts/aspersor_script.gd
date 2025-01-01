extends Machine
class_name Aspersor

# level 1: 2 celdas alrededor, con tanque
# level 2: 1 celda alrededor, con ca;erias
# level 3: 2 celdas alrededor, ca;erias

# the machine should be a child of the grid or sth like that

signal interact(pos, game_grid)
var cells = []
var pos
var powered_on = false
var water_level: float = 0 # MAX = 20
var timer = Timer.new()
var progress_bar = TextureProgressBar.new()

func setup(pos, game_grid):
	if level == 2: #stupid AF but works
		progress_bar.value = water_level
		progress_bar.min_value = 0
		progress_bar.max_value = 100 
		progress_bar.step = 1
		#progress_bar.show_percentage = true
		progress_bar.size = Vector2(128, 128)
		progress_bar.position = Vector2(game_grid.map_to_local(pos).x-66,game_grid.map_to_local(pos).y-40)
		progress_bar.texture_progress = preload("res://art/PressureWaterBar.png")
		progress_bar.visible = false
		#progress_bar.fill_mode = 3
		#progress_bar.fill_mode =
		game_grid.add_child(progress_bar)
	timer.wait_time = 1
	timer.one_shot = false
	game_grid.add_child(timer)
	timer.start(1)
	timer.timeout.connect(func():
		if(level==1):
			if(powered_on):
				if water_level > 5:
					water_level -= 1
					for cell in cells:
						if game_grid.grid[cell].in_use:
							game_grid.grid[cell].humidity += 2
							game_grid.grid[cell].onChangedCell.emit(cell)
		if(level==2):
			progress_bar.value = water_level*10
			if water_level > 5:
				powered_on = true
				water_level -= 1
				for cell in cells:
					if game_grid.grid[cell].in_use:
						game_grid.grid[cell].humidity += 1
						game_grid.grid[cell].onChangedCell.emit(cell)
			else:
				powered_on = false
	)
	if level == 1:
		interact.connect(func(pos, game_grid):
			powered_on = !powered_on
			if powered_on:
				timer.paused = false
			else:
				timer.paused = true
			game_grid.updateCellTile(pos)
		)
	if level == 2:
		interact.connect(func(pos, game_grid):
			print("water level: ", water_level)
		)
	cells.append(Vector2(pos.x, pos.y+1))
	cells.append(Vector2(pos.x+1, pos.y))
	cells.append(Vector2(pos.x+1, pos.y+1))
	if pos.y > 0:
		cells.append(Vector2(pos.x+1, pos.y-1))
	if(pos>=Vector2(0 ,0)):
		if pos.y > 0:
			cells.append(Vector2(pos.x, pos.y-1))
		if pos.x > 0:
			cells.append(Vector2(pos.x-1, pos.y))
			cells.append(Vector2(pos.x-1, pos.y+1))
		if pos.x > 0 and pos.y > 0:
			cells.append(Vector2(pos.x-1, pos.y-1))
	#self.add_child(timer)
	

func _init(_name, _descriptcion, _texture, _level, _resource, _fuel):
	name = _name
	description = _descriptcion
	texture = _texture
	
	level = _level
	
	resource = _resource
	fuel = _fuel
