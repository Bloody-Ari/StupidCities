extends Area2D

#@export to allow modification through the editor
@export  var speed               = 400
@export  var inventory: Array = [ToolList.tool_list["hoe"], ToolList.tool_list["gloves"], ToolList.tool_list["sprinkler"], ToolList.tool_list["sunflower_seeds_bag"], ToolList.tool_list["plastic_bag"]]
@onready var game_grid = $"../Grid"
@onready var left_hotbar = $"Hotbars/Left Hotbar"
@onready var right_hotbar = $"Hotbars/Right Hotbar"
@onready var camera = $Camera2D
@onready var hotbars = $Hotbars
@onready var pause_menu = $PauseMenu2/PauseMenu
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
var right_bar_full = false
var left_bar_full = false
var inventory_lock = false
@onready var inventory_full_dialog = $ColorRect
@onready var not_enough_seeds_dialog = $NoEnoughSeeds

signal using(cell: Vector2, tool: String, hand: String)
signal longPressRight(game_grid)
signal longPressLeft(game_grid)

var showing_inventory_full_dialog = false

func _onNotEnoughSeeds():
	if not_enough_seeds_dialog.visible:
		return
	not_enough_seeds_dialog.visible = true
	var timer = Timer.new()
	add_child(timer)
	timer.start(2)
	timer.timeout.connect(func():
		not_enough_seeds_dialog.visible = false
	)

func onInventoryFull():
	if showing_inventory_full_dialog:
		return
	showing_inventory_full_dialog = true
	inventory_full_dialog.visible = true
	print("Your inventory is full")
	var timer = Timer.new()
	add_child(timer)
	timer.start(2)
	timer.timeout.connect(func():
		inventory_full_dialog.visible = false
		showing_inventory_full_dialog = false
	)

func check_if_hotbar_is_full():
	if left_hotbar_contents.count(null) == 0:
		left_bar_full = true
	else:
		left_bar_full = false
	if right_hotbar_contents.count(null) == 0:
		right_bar_full = true
	else:
		right_bar_full = false
	if right_bar_full && left_bar_full:
		inventory_lock = true
	else:
		inventory_lock = false

func toggle_menu():
	print("Toggling pause menu")
	pause_menu.visible = !pause_menu.visible
	get_tree().paused = !get_tree().paused

func _adjust_hotbars(): 
	# get items, if item is sunflowerbag or plastic bags adjust text
	var index = 0
	var bag_text = null
	left_hotbar_contents.sort()
	right_hotbar_contents.sort()
	for item in left_hotbar_contents:
		if(item == null):
			index += 1
			continue
		if(item.name == "Empty Plastic Bag" or item.name == "Sunflower Seeds Bag"):
			#left_hotbar.position
			bag_text = left_hotbar.get_child(0)
			if bag_text != null:
				bag_text.set_position(Vector2(64*(index+1), 0))
		index += 1
	for item in right_hotbar_contents:
		if(item == null):
			index += 1
			continue
		if(item.name == "Sunflower Seeds Bag"):
			#left_hotbar.position
			bag_text = right_hotbar.get_child(0)
			#right_hotbar.set_item_text(index, str(index%10))
			if bag_text != null:
				bag_text.text = str(inventory[inventory.find(ToolList.tool_list["sunflower_seeds_bag"])].seeds_available)
				bag_text.set_position(Vector2(64*(index-9)-32, 0))
		index += 1
	check_if_hotbar_is_full()

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
		#if(removed_items >= n ):
			#break
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
				right_hotbar.set_item_text(i, str((i+1)%10))
				i+=1
		i=0
		for _item in left_hotbar_contents:
			if _item != null:
				left_hotbar.set_item_text(i, str((i+1)%10))
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
			left_hotbar.set_item_text(i, str((i+1)%10))
			i+=1
	i=0
	for _item in right_hotbar_contents:
		if _item != null:
			right_hotbar.set_item_text(i, str((i+1)%10))
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
		right_hotbar_contents[10-right_hotbar_contents.count(null)] = item
		right_hotbar.add_item(str(10-right_hotbar_contents.count(null)), item.texture, true)
		check_if_hotbar_is_full()
	else:
		left_hotbar_contents[10-left_hotbar_contents.count(null)] = item
		left_hotbar.add_item(str(10-left_hotbar_contents.count(null)), item.texture, true)
		check_if_hotbar_is_full()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = false
	right_hotbar_contents.resize(10)
	left_hotbar_contents.resize(10)
	#print_inventory()
	right_hotbar_contents[0] = inventory[0]
	right_hotbar.add_item("1", preload("res://art/Hoe.png"), true)
	right_hotbar_contents[1]  = inventory[3]
	right_hotbar.add_item("2", preload("res://art/SunFlowerSeedsBagItem.png"), true)
	
	seeds_bag_quantity.text = str(inventory[3].seeds_available)
	seeds_bag_quantity.set_position(Vector2(64*2-32, 0))
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
	use_progress_bar.max_value = 1.5
	use_progress_bar.value = 0
	use_progress_bar.size = Vector2(200, 20)
	use_progress_bar.position = Vector2(position.x+280, position.y+100)
	hotbars.add_child(use_progress_bar)
	humidity_label.visible = true
	add_child(humidity_label)
	
	inventory[4].not_enough_seeds.connect(_onNotEnoughSeeds)
	

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
	if press >= 1.5:
		if right_click_tool == null:
			game_grid.remove_pipe(Vector2(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position()))))
		else:
			print("Using right")
			right_click_tool.use(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())), game_grid)
		right_press = 0

func _onLongPressLeft(press):
	if press >= 1.5:
		if left_click_tool == null:
			game_grid.remove_pipe(Vector2(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position()))))
		else:
			print("Using left")
			left_click_tool.use(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())), game_grid)
		left_press = 0

# KISS 
# aaaaand I can't really use pointers so I cant get that smart with this
func SelectFromRightHotbar(item_index: int):
	if right_click_tool == right_hotbar_contents[item_index]:
		right_click_tool = null
		right_hotbar.deselect_all()
		right_hotbar.release_focus()
	else:
		right_click_tool = right_hotbar_contents[item_index]
		right_hotbar.select(item_index)

func SelectFromLeftHotbar(item_index: int):
	if left_click_tool == left_hotbar_contents[item_index]:
		left_click_tool = null
		left_hotbar.deselect_all()
		left_hotbar.release_focus()
	else:
		left_click_tool = left_hotbar_contents[item_index]
		left_hotbar.select(item_index)

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
		SelectFromLeftHotbar(0)

	if Input.is_action_just_pressed("select_left_hotbar_two") and !Input.is_action_just_pressed("select_right_hotbar_two"):
		SelectFromLeftHotbar(1)

	if Input.is_action_just_pressed("select_left_hotbar_three") and !Input.is_action_just_pressed("select_right_hotbar_three"):
		SelectFromLeftHotbar(2)
	
	if Input.is_action_just_pressed("select_left_hotbar_four") and !Input.is_action_just_pressed("select_right_hotbar_four"):
		SelectFromLeftHotbar(3)

	if Input.is_action_just_pressed("select_left_hotbar_five") and !Input.is_action_just_pressed("select_right_hotbar_five"):
		SelectFromLeftHotbar(4)

	if Input.is_action_just_pressed("select_left_hotbar_six") and !Input.is_action_just_pressed("select_right_hotbar_six"):
		SelectFromLeftHotbar(5)
	
	if Input.is_action_just_pressed("select_left_hotbar_seven") and !Input.is_action_just_pressed("select_right_hotbar_seven"):
		SelectFromLeftHotbar(6)
	if Input.is_action_just_pressed("select_left_hotbar_eight") and !Input.is_action_just_pressed("select_right_hotbar_eight"):
		SelectFromLeftHotbar(7)
	if Input.is_action_just_pressed("select_left_hotbar_sevennine") and !Input.is_action_just_pressed("select_right_hotbar_nine"):
		SelectFromLeftHotbar(8)
	if Input.is_action_just_pressed("select_left_hotbar_ten") and !Input.is_action_just_pressed("select_right_hotbar_ten"):
		SelectFromLeftHotbar(9)
		
	if Input.is_action_just_pressed("select_right_hotbar_one"):
		SelectFromRightHotbar(0)
		#This is the previous way to do it, I am leaving it here just in case
		#right_click_tool = right_hotbar_contents[0]
		#right_hotbar.select(0)
		
	if Input.is_action_just_pressed("select_right_hotbar_two"):
		SelectFromRightHotbar(1)
	if Input.is_action_just_pressed("select_right_hotbar_three"):
		SelectFromRightHotbar(2)
	if Input.is_action_just_pressed("select_right_hotbar_four"):
		SelectFromRightHotbar(3)
	if Input.is_action_just_pressed("select_right_hotbar_five"):
		SelectFromRightHotbar(4)
	if Input.is_action_just_pressed("select_right_hotbar_six"):
		SelectFromRightHotbar(5)
	if Input.is_action_just_pressed("select_right_hotbar_seven"):
		SelectFromRightHotbar(6)
	if Input.is_action_just_pressed("select_right_hotbar_eight"):
		SelectFromRightHotbar(7)
	if Input.is_action_just_pressed("select_right_hotbar_nine"):
		SelectFromRightHotbar(8)
	if Input.is_action_just_pressed("select_right_hotbar_ten"):
		SelectFromRightHotbar(9)

	if Input.is_action_just_pressed("Open Inventory"):
		#_toggle_inventory()
		#_adjust_hotbars()
		game_grid.UsingCell.emit(self.position)


	if Input.is_action_pressed("use_right"):
		if using_left:
			return
		if(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).x < 0 or game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).y < 0):
			#print("Out of bounds")
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
		if(game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).x < 0 or game_grid.local_to_map(game_grid.to_local(game_grid.get_global_mouse_position())).y < 0):
			#print("Out of bounds")
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
		
	if Input.is_action_just_pressed("OpenMenu"):
		toggle_menu()

func _on_right_hotbar_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if right_click_tool == right_hotbar_contents[index]:
		right_click_tool = null
		right_hotbar.deselect_all()
		right_hotbar.release_focus()
	else:
		right_click_tool = right_hotbar_contents[index]
	#update_tools()

func _on_left_hotbar_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if left_click_tool == left_hotbar_contents[index]:
		left_click_tool = null
		left_hotbar.deselect_all()
		left_hotbar.release_focus()
	else:
		left_click_tool = left_hotbar_contents[index]
	#update_tools()
