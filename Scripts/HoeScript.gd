extends Tool
class_name Hoe

func use(pos: Vector2, game_grid: GameGrid):
	var cell_state = game_grid.grid[pos].state
	match self.level:
		1:
			if cell_state != "PlainTerrain":
				game_grid.grid[pos].plant_state = "Plowed"
				game_grid.grid[pos].onChangedCell.emit(pos)
		2:
			if cell_state != "PlainTerrain":
				game_grid.grid[pos].plant_state = "Plowed"
				game_grid.grid[pos].onChangedCell.emit(pos)
			if(game_grid.grid[Vector2(pos.x+1, pos.y)].in_use):
				game_grid.grid[Vector2(pos.x+1, pos.y)].plant_state = "Plowed"
				game_grid.grid[Vector2(pos.x+1, pos.y)].onChangedCell.emit(Vector2(pos.x+1, pos.y))
			if(game_grid.grid[Vector2(pos.x, pos.y+1)].in_use):
				game_grid.grid[Vector2(pos.x, pos.y+1)].plant_state = "Plowed"
				game_grid.grid[Vector2(pos.x, pos.y+1)].onChangedCell.emit(Vector2(pos.x, pos.y+1))
			if(game_grid.grid[Vector2(pos.x+1, pos.y+1)].in_use):
				game_grid.grid[Vector2(pos.x+1, pos.y+1)].plant_state = "Plowed"
				game_grid.grid[Vector2(pos.x+1, pos.y+1)].onChangedCell.emit(Vector2(pos.x+1, pos.y+1))

"""
		2:
			if(game_grid.grid[pos].in_use):
				game_grid.grid[pos].humidity += 1
				game_grid.grid[pos].onChangedCell.emit(pos)
			
			if(game_grid.grid[Vector2(pos.x+1, pos.y)].in_use):
				game_grid.grid[Vector2(pos.x+1, pos.y)].humidity  +=1
				game_grid.grid[Vector2(pos.x+1, pos.y)].onChangedCell.emit(Vector2(pos.x+1, pos.y))
			
			if(game_grid.grid[Vector2(pos.x, pos.y+1)]):
				game_grid.grid[Vector2(pos.x, pos.y+1)].humidity += 1
				game_grid.grid[Vector2(pos.x, pos.y+1)].onChangedCell.emit(Vector2(pos.x, pos.y+1))
			
			if(game_grid.grid[Vector2(pos.x+1, pos.y+1)].in_use):
				game_grid.grid[Vector2(pos.x+1, pos.y+1)].humidity +=1
				game_grid.grid[Vector2(pos.x+1, pos.y+1)].onChangedCell.emit(Vector2(pos.x+1, pos.y+1))
"""
