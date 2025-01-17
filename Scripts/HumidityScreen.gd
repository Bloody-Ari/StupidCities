extends Tool
class_name HumidityScreen

func use(pos: Vector2, game_grid: GameGrid):
	print("Using screen!")
	print("Cells with checkers")
	for cell in game_grid.humidity_network:
		var timer = Timer.new()
		game_grid.add_child(timer)
		timer.start(3)
		print(cell)
		game_grid.grid[cell].humidity_label.text[-1] = str(int(game_grid.grid[cell].humidity))
		game_grid.grid[cell].humidity_label.visible = true
		timer.timeout.connect(func():
			game_grid.grid[cell].humidity_label.visible = false
			game_grid.remove_child(timer)
		)
