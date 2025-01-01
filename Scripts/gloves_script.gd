extends Tool
class_name Gloves

func use(pos: Vector2, game_grid: GameGrid):
	var cells = []
	cells.append(pos)
	if self.level == 2:
			cells.append(Vector2(pos.x, pos.y+1))
			cells.append(Vector2(pos.x+1, pos.y))
			cells.append(Vector2(pos.x+1, pos.y+1))
	for cell in cells:
		if game_grid.grid[cell].plant_state != "None":
			if game_grid.grid[cell].plant_state == "FullyGrown":
				game_grid.PickedUpSeeds.emit(2)
				game_grid.grid[cell].plant_state = "None"
			else:
				if game_grid.grid[cell].plant_state == "DrownedPlant":
					game_grid.grid[cell].plant_state = "None"
				else:
					game_grid.PickedUpSeeds.emit(1)
					game_grid.grid[cell].plant_state = "None"
		if game_grid.grid[cell].humidity >= 5:
			game_grid.grid[cell].state = "PlainDirt"
		game_grid.grid[cell].in_use = true
		game_grid.grid[cell].onChangedCell.emit(cell)
