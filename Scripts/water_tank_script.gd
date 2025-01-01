extends Machine
class_name WaterTank

signal interact(pos, game_grid)

var water_level # L?? who knows, it's at 100% and that's it

func show_water_level(pos, game_grid):
	print("Water level: ", water_level)
	var water_label = Label.new()
	water_label.text = "Water level: " + str(water_level) + "%"
	water_label.set_position(Vector2(game_grid.map_to_local(to_local(pos)).x-64, game_grid.map_to_local(to_local(pos)).y-86))
	game_grid.add_child(water_label)
	var timer = Timer.new()
	game_grid.add_child(timer)
	timer.start(2)
	timer.timeout.connect(func():
		game_grid.remove_child(water_label)
		game_grid.remove_child(timer)
	)

func _init(_name, _descriptcion, _texture, _level, _resource, _fuel, _water_level):
	name = _name
	description = _descriptcion
	texture = _texture
	
	level = _level
	
	resource = _resource
	fuel = _fuel
	interact.connect(show_water_level)
	water_level = _water_level
	print("Placed Water Tank")
	#var refill_timer = Timer.new() every X seconds it should refill
