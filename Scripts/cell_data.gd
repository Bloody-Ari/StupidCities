extends Object
class_name CellData

signal onChangedCell(_pos: Vector2)

var state: String #should be FloorType or sth like that, for now it's all spaghetti  
var plant_state: String = "None"
var plant_type: String = "None"
var humidity: float = 7
var timer = Timer.new()
var counter = 0
var final_time = 3
var rot_timer = 0 # la podes ahogar
var dry_timer = 0
var first_grow_time = 1
var second_grow_time = 2
var third_grow_time = 4
var fully_grown_time = 6
var machine_state : String = "None" #you can have a machine OR a flower, not both
var machine: Machine = null
var pipe_state = null
var pipe_label
var humidity_label = Label.new()
var valve_state = null
var aysa = false
var humidity_checker_type = null
var humidity_checker = null

"""
States:
	PlainTerrain
	DryDirt
	PlainDirt
	WetDirt
PlanStates:
	None
	Plowed
	Planted
	FirstGrow
	SecondGrow
	ThirdGrow
	FullyGrown
"""
var position: Vector2
var in_use: bool = false#if in use humidty runs

func _init(_state, _position):
	state = _state
	position = _position
