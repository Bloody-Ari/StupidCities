extends Area2D

#@export to allow modification through the editor
@export  var speed               = 400
@export  var inventory: Array = [ToolList.tool_list["hoe"], ToolList.tool_list["gloves"], ToolList.tool_list["sprinkler"], ToolList.tool_list["sunflower_seeds_bag"], ToolList.tool_list["plastic_bag"]]
@onready var game_grid = $"../Grid"
@onready var left_hotbar = $"Hotbars/Left Hotbar"
@onready var right_hotbar = $"Hotbars/Right Hotbar"
@onready var camera = $Camera2D
@onready var hotbars = $Hotbars
var right_hotbar_contents: Array = []
var left_hotbar_contents: Array = []
@export var money = 100
@onready var wire_layer = $"../WireLayer"
var using_right = false
var using_left = false

var zoom_speed: float = 0.05
var zoom_min: float = 0.001
var zoom_max: float = 2.0
var drag_sensitivity: float = 1

var screen_size
var right_click_tool = null
var left_click_tool  = null

var seeds_bag_quantity = Label.new()
var empty_plastic_bag_quantity = Label.new()
var ten_seed_bag_quantity = Label.new()
var bucket_level_label = Label.new()
var humidity_label = Label.new()

var use_progress_bar = ProgressBar.new()

var right_press = 0
var left_press = 0

signal using(cell: Vector2, tool: String, hand: String)
signal longPressRight(game_grid)
signal longPressLeft(game_grid)

func _adjust_hotbars(): 
	# get items, if item is sunflowerbag or plastic bags adjust text
	var index = 0
	var bag_text = null
	for item in left_hotbar_contents:
		if(item == null):
			index += 1
			continue
		if(item.name == "Empty Plastic Bag"):
			#left_hotbar.position
			bag_text = left_hotbar.get_child(0)
			if bag_text != null:
				bag_text.set_position(Vector2(64*(index+1), 0))
		index += 1
	for item in right_hotbar_contents:
		if(item == null):
			index += 1
			continue
		if(item.name == "Empty Plastic Bag"):
			#left_hotbar.position
			bag_text = right_hotbar.get_child(0)
			if bag_text != null:
				bag_text.set_position(Vector2(64*(index+1), 0))
		index += 1

func print_inventory():
	print("Inventory:")
	for item in inventory:
		if(item != null):
			print(item.name)

func _toggle_inventory():
	print("Inventory:")
	for item in inventory:
		if(item != null):
			if(typeof(item)!= TYPE_INT):
				print(item.name)
			else:
				print(item)

func remove_n_from_inventory(item, n):
	var i=0
	var removed_items = 0
	var removed_from_inventory = 0
	while(removed_items < n and removed_from_inventory < n):
		for _item in inventory:
			if typeof(_item)== TYPE_INT:
				i+=1
				continue
			if removed_from_inventory >= n:
				break
			if _item == item:
				inventory.remove_at(i)
				removed_from_inventory += 1
			i += 1
		i=0
		for _item in right_hotbar_contents:
			if _item == item and removed_items < n:
				right_hotbar_contents.remove_at(i)
				right_hotbar_contents.append(null)
				right_hotbar.remove_item(i)
				removed_items += 1
			i+=1
		i=0
		if(removed_items >= n ):
			break
		for _item in left_hotbar_contents:
			if _item == item and removed_items < n:
				left_hotbar_contents.remove_at(i)
				left_hotbar_contents.append(null)
				left_hotbar.remove_item(i)
				removed_items += 1
			i+=1
		i=0
		for _item in right_hotbar_contents:
			if _item != null:
				right_hotbar.set_item_text(i, str(i+1))
				i+=1
		i=0
		for _item in left_hotbar_contents:
			if _item != null:
				left_hotbar.set_item_text(i, str(i+1))
				i+=1
	if left_click_tool == item:
		left_click_tool = null
		using_left = false
		use_progress_bar.value = 0
		use_progress_bar.visible = false
		left_press = 0
	if right_click_tool == item:
		right_click_tool = null
		using_right = false
		use_progress_bar.value = 0
		use_progress_bar.visible = false
		right_press = 0
	_adjust_hotbars()

func remove_from_inventory(item):
	var i=0
	for _item in inventory:
		if typeof(_item)== TYPE_INT:
			continue
		if _item == item:
			inventory.remove_at(i)
		i += 11
	i=0
	for _item in right_hotbar_contents:
		if _item == item:
			right_hotbar_contents[i] = null
			right_hotbar.remove_item(i)
			#fix items
		i+=1
	i=0
	for _item in left_hotbar_contents:
		if _item == item:
			left_hotbar_contents[i] = null
			left_hotbar.remove_item(i)
		i+=1
	#inventory.remove_at()
	#fix hotabars
	i=0
	for _item in left_hotbar_contents:
		if _item != null:
			left_hotbar.set_item_text(i, str(i+1))
			i+=1
	i=0
	for _item in right_hotbar_contents:
		if _item != null:
			right_hotbar.set_item_text(i, str(i+1))
			i+=1
	if left_click_tool == item:
		left_click_tool = null
	if right_click_tool == item:
		right_click_tool = null
	_adjust_hotbars()

#I need to add a check for stacking, plastic bags at least
#I also have to add a chest and a proper inventory maybe
func append_to_inventory(item):
	inventory.append(item)
	if right_hotbar_contents.count(null) > left_hotbar_contents.count(null):
		right_hotbar_contents[9-right_hotbar_contents.count(null)] = item
		right_hotbar.add_item(str(9-right_hotbar_contents.count(null)), item.texture, true)
	else:
		left_hotbar_contents[9-left_hotbar_contents.count(null)] = item
		left_hotbar.add_item(str(9-left_hotbar_contents.count(null)), item.texture, true)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = false
	right_hotbar_contents.resize(9)
	left_hotbar_contents.resize(9)
	#print_inventory()
	right_hotbar_contents[0] = inventory[0]
	right_hotbar.add_item("1", preload("res://art/Hoe.png"), true)
	right_hotbar_contents[1]  = inventory[3]
	right_hotbar.add_item("2", preload("res://art/SunFlowerSeedsBagItem.png"), true)
	
	seeds_bag_quantity.text = str(inventory[3].seeds_available)
	seeds_bag_quantity.set_position(Vector2(64*3-32, 0))
	right_hotbar.add_child(seeds_bag_quantity)
	empty_plastic_bag_quantity.text = str(inventory[4].quantity)
	empty_plastic_bag_quantity.set_position(Vector2(64*3, 0))
	left_hotbar.add_child(empty_plastic_bag_quantity)
	
	left_hotbar_contents[0]  = inventory[1]
	left_hotbar.add_item("1", preload("res://art/Gloves.png"), true)
	left_hotbar_contents[1]  = inventory[2]
	left_hotbar.add_item("2", preload("res://art/Sprinkler.png"), true)
	left_hotbar_contents[2]  = inventory[4]
	left_hotbar.add_item("3", preload("res://art/EmptyPlasticBag.png"), true)
	add_child(ten_seed_bag_quantity)
	add_child(bucket_level_label)
	screen_size = get_viewport_rect().size
	
	longPressRight.connect(_onLongPressRight)
	longPressLeft.connect(_onLongPressLeft)
	
	use_progress_bar.visible = false
	use_progress_bar.min_value = 0
	use_progress_bar.max_value = 2
	use_progress_bar.value = 0
	use_progress_bar.size = Vector2(200, 20)
	use_progress_bar.position = Vector2(position.x-100, position.y-100)
	hotbars.add_child(use_progress_bar)
	humidity_label.visible = true
	add_child(humidity_label)
#you have 2 different sets of hotbars, one for right click, 1-0 
#and one for left click shift 1-0
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom += Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom -= Vector2(zoom_speed, zoom_speed)
		camera.zoom = clamp(camera.zoom, Vector2(zoom_min, zoom_min), Vector2(zoom_max, zoom_max))

func update_tools():
	if(right_click_tool != null):
		print("Right click tool: ", right_click_tool.name)
	if(left_click_tool != null):
		print("Left click tool: ", left_click_tool.name)

func _onLongPressRight(press):
	if press >= 2:
		right_click_tool.use(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())), game_grid)
		right_press = 0

func _onLongPressLeft(press):
	if press >= 2:
		left_click_tool.use(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())), game_grid)
		left_press = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, Vector2(game_grid.width*128, game_grid.height*128))
	humidity_label.position = Vector2(position.x/128-100, position.y/128-100)
	game_grid.onCell.emit(position)

	if Input.is_action_just_pressed("select_left_hotbar_one") and !Input.is_action_pressed("select_right_hotbar_one"): #as spaggeti as it gets LOL
		left_click_tool = left_hotbar_contents[0]
		left_hotbar.select(0)
		#update_tools() #idk if I'll use it for sth like sprites but for now just to print shit
	if Input.is_action_just_pressed("select_left_hotbar_two") and !Input.is_action_just_pressed("select_right_hotbar_two"):
		left_click_tool = left_hotbar_contents[1]
		left_hotbar.select(1)
		#update_tools()
	if Input.is_action_just_pressed("select_left_hotbar_three") and !Input.is_action_just_pressed("select_right_hotbar_three"):
		left_click_tool = left_hotbar_contents[2]
		left_hotbar.select(2)
		#update_tools()
	if Input.is_action_just_pressed("select_left_hotbar_four") and !Input.is_action_just_pressed("select_right_hotbar_four"):
		left_click_tool = left_hotbar_contents[3]
		left_hotbar.select(3)
		#update_tools()
	if Input.is_action_just_pressed("select_left_hotbar_five") and !Input.is_action_just_pressed("select_right_hotbar_five"):
		left_click_tool = left_hotbar_contents[4]
		left_hotbar.select(4)
		#update_tools()
	if Input.is_action_just_pressed("select_left_hotbar_six") and !Input.is_action_just_pressed("select_right_hotbar_six"):
		left_click_tool = left_hotbar_contents[5]
		left_hotbar.select(5)
		#update_tools()
	if Input.is_action_just_pressed("select_right_hotbar_one"):
		right_click_tool = right_hotbar_contents[0]
		right_hotbar.select(0)
		#update_tools()
	if Input.is_action_just_pressed("select_right_hotbar_two"):
		right_click_tool = right_hotbar_contents[1]
		right_hotbar.select(1)
		#update_tools()
	if Input.is_action_just_pressed("select_right_hotbar_three"):
		right_click_tool = right_hotbar_contents[2]
		right_hotbar.select(2)
		#update_tools()
	if Input.is_action_just_pressed("select_right_hotbar_four"):
		right_click_tool = right_hotbar_contents[3]
		right_hotbar.select(3)
		#update_tools()
	if Input.is_action_just_pressed("select_right_hotbar_five"):
		right_click_tool = right_hotbar_contents[4]
		right_hotbar.select(4)
		#update_tools()
	if Input.is_action_just_pressed("select_right_hotbar_six"):
		right_click_tool = right_hotbar_contents[5]
		right_hotbar.select(5)
		#update_tools()

	if Input.is_action_just_pressed("Open Inventory"):
		#_toggle_inventory()
		#_adjust_hotbars()
		game_grid.UsingCell.emit(self.position)


	if Input.is_action_pressed("use_right"):
		if using_left:
			return
		if(right_click_tool == null):
			print("got null tool on right hand")
			return
		if(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).x < 0 or game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).y < 0):
			print("Out of bounds")
			return
		using_right = true
		#use_progress_bar.position = position
		use_progress_bar.visible = true
		use_progress_bar.value = right_press
		right_press += delta
		#use_progress_bar.position = Vector2(position.x, position.y)
		longPressRight.emit(right_press)
	elif right_press > 0:
		right_press = 0
		use_progress_bar.value = 0
		use_progress_bar.visible = false
		using_right=false
		
	if Input.is_action_pressed("use_left"):
		if using_right:
			return
		if(left_click_tool == null):
			print("got null tool on left hand")
			return
		if(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).x < 0 or game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).y < 0):
			print("Out of bounds")
			return
		using_left =true
		use_progress_bar.visible = true
		use_progress_bar.value = left_press
		left_press += delta
		longPressLeft.emit(left_press)
	elif left_press > 0:
		using_left = false
		left_press = 0
		use_progress_bar.value = 0
		use_progress_bar.visible = false
		#emit signal
	if Input.is_action_just_pressed("Place Wire"):
		#print(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())))
		wire_layer.add_cell(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())))

func _on_right_hotbar_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	right_click_tool = right_hotbar_contents[index]
	#update_tools()


func _on_left_hotbar_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	left_click_tool = left_hotbar_contents[index]
	#update_tools()
