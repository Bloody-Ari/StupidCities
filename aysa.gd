extends Area2D

@onready var aysa_plans = $AysaPlans
@onready var game_grid = $"../Grid"
@onready var aysa_timer = $AysaTimer
@onready var player = $"../Player"
@onready var label = $Label
var selected_plan = -1
var prices = [150, 300, 450, 650]
var water_reserve = 0
var pipes_timer = Timer.new()
var time_until_next_update = 60
var water_reserve_label = Label.new()

func _onAysaEnter(area_rid, area, area_shape_index, local_shape_index):
	aysa_plans.visible = true
	water_reserve_label.visible = true
	label.visible = true

func _onAysaExit(area_rid, area, area_shape_index, local_shape_index):
	aysa_plans.visible = false
	water_reserve_label.visible = false
	label.visible = false
#deberia poner una label con next update in: 
func _onAysaSelectedPlan(index):
	if index == 4:
		selected_plan = -1
	else:
		selected_plan = index

func _onAysaTimer():
	print("Updated your water reservs with level: ", selected_plan)
	if selected_plan < 0:
		return
	if player.money >= prices[selected_plan]:
		player.money -= prices[selected_plan]
		game_grid.ChangeMoneroAmount.emit(player.money)
		match selected_plan:
			0:
				water_reserve = 25
			1:
				water_reserve = 50
			2:
				water_reserve = 75
			3:
				water_reserve = 100

func _onPipeTimer():
	if water_reserve > 0 and game_grid.grid[Vector2(0,0)].pipe_state <= 7:
		game_grid.grid[Vector2(0,0)].pipe_state += 2
		water_reserve -= 1
	if time_until_next_update > 0:
		time_until_next_update-=1
	else:
		time_until_next_update = 60
	label.text = "Time until next update: " + str(time_until_next_update)
	water_reserve_label.text = "Water left: " + str(water_reserve)

func setup():
	game_grid.grid[Vector2(0,0)].aysa = true
	game_grid.grid[Vector2(0,0)].pipe_state = 9
	game_grid.grid[Vector2(0,0)].pipe_label = Label.new()
	game_grid.grid[Vector2(0,0)].pipe_label.text ="9"
	game_grid.grid[Vector2(0,0)].pipe_label.visible = false
	game_grid.grid[Vector2(0,0)].pipe_label.position = Vector2(0, 0)
	game_grid.add_child(game_grid.grid[Vector2(0,0)].pipe_label)
	game_grid.pipes_grid.append(Vector2(0,0))
	game_grid.pipes_grid.sort()
	game_grid.updateCellTile(Vector2(0,0))
	add_child(pipes_timer)
	pipes_timer.start(1)
	pipes_timer.timeout.connect(_onPipeTimer)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_shape_entered.connect(_onAysaEnter)
	self.area_shape_exited.connect(_onAysaExit)
	aysa_plans.visible = false
	aysa_plans.add_item("150 -1/4 tanque por minuto")
	aysa_plans.add_item("300 -2/4 tanque por minuto")
	aysa_plans.add_item("450 -3/4 tanque por minuto")
	aysa_plans.add_item("650 -1 tanque por minuto")
	aysa_plans.add_item("Cancel")
	aysa_plans.item_selected.connect(_onAysaSelectedPlan)
	aysa_timer.timeout.connect(_onAysaTimer)
	aysa_timer.start(60)
	label.text = "Time until next update: " + str(time_until_next_update)
	water_reserve_label.position = Vector2(label.position.x, label.position.y-15)
	water_reserve_label.text = "Water left: " + str(water_reserve)
	add_child(water_reserve_label)
	water_reserve_label.visible = false
	label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
