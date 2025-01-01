extends Tool
class_name Sprinkler

var water_level = 10 # max for level 1, each second uses 1 unit and raises 1 humidity point
func use(pos: Vector2, game_grid: GameGrid):
	match self.level:
		1:
			game_grid.grid[pos].humidity += 2
			game_grid.grid[pos].onChangedCell.emit(pos)
			game_grid.grid[pos].in_use = true
		2:
			if(game_grid.grid[pos].in_use):
				game_grid.grid[pos].humidity += 2
				game_grid.grid[pos].onChangedCell.emit(pos)
			
			if(game_grid.grid[Vector2(pos.x+1, pos.y)].in_use):
				game_grid.grid[Vector2(pos.x+1, pos.y)].humidity  +=2
				game_grid.grid[Vector2(pos.x+1, pos.y)].onChangedCell.emit(Vector2(pos.x+1, pos.y))
			
			if(game_grid.grid[Vector2(pos.x, pos.y+1)].in_use):
				game_grid.grid[Vector2(pos.x, pos.y+1)].humidity += 2
				game_grid.grid[Vector2(pos.x, pos.y+1)].onChangedCell.emit(Vector2(pos.x, pos.y+1))
			
			if(game_grid.grid[Vector2(pos.x+1, pos.y+1)].in_use):
				game_grid.grid[Vector2(pos.x+1, pos.y+1)].humidity +=2
				game_grid.grid[Vector2(pos.x+1, pos.y+1)].onChangedCell.emit(Vector2(pos.x+1, pos.y+1))
