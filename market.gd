extends Area2D

@onready var player = $"../Player"
@onready var buying_bar = $"Buying Bar"
@onready var machine_buy_bar = $"MachineBuy"
@onready var shape = $CollisionShape2D 
@onready var grid = $"../Grid"
@onready var button = $"Button"
signal inventoryFull()
func _onSellRightClick():
	if player.right_click_tool != null:	
		if player.right_click_tool.name != "Empty Plastic Bag" and player.right_click_tool.name != "Sunflower Seeds Bag":
			player.money += int(70 * player.right_click_tool.price / 100)
			player.remove_n_from_inventory(player.right_click_tool, 1)
			grid.ChangeMoneroAmount.emit(player.money)
	button.release_focus()

func _onSellLeftClick():
	if player.left_click_tool == null:
		return
	if player.left_click_tool.name != "Empty Plastic Bag" and player.left_click_tool.name != "Sunflower Seeds Bag":
		player.money += int(70 * player.left_click_tool.price / 100)
		player.remove_n_from_inventory(player.left_click_tool, 1)
		grid.ChangeMoneroAmount.emit(player.money)
	button.release_focus()

func _onMarketEnter(area_rid, area, area_shape_index, local_shape_index):
	buying_bar.visible = true
	machine_buy_bar.visible = true
	button.visible = true

func _onMarketExit(area_rid, area, area_shape_index, local_shape_index):
	buying_bar.visible = false
	machine_buy_bar.visible = false
	button.visible = false

func _onSelectedFromBuyBar(item_index):
	if player.inventory_lock:
		inventoryFull.emit()
		buying_bar.deselect_all()
		buying_bar.release_focus()
		return
	var regex = RegEx.new()
	regex.compile("[0-9]*")
	var result = regex.search(buying_bar.get_item_text(item_index))
	if result:
		if player.money >= int(result.get_string()):
			player.money -= int(result.get_string())
			grid.ChangeMoneroAmount.emit(player.money)
			if(buying_bar.get_item_text(item_index).split("-")[1] == "Empty Plastic Bag"):
				player.inventory[player.inventory.find(ToolList.tool_list["plastic_bag"])].quantity += 1
				player.empty_plastic_bag_quantity.text = str(player.inventory[player.inventory.find(ToolList.tool_list["plastic_bag"])].quantity)
			else:
				if(buying_bar.get_item_text(item_index).split("-")[1] == "sunflower_seeds_bag"):
					player.inventory[player.inventory.find(ToolList.tool_list["sunflower_seeds_bag"])].seeds_available += 1
					player._adjust_hotbars()
				else:
					player.append_to_inventory(ToolList.tool_list[buying_bar.get_item_text(item_index).split("-")[1]])
					if(buying_bar.get_item_text(item_index).split("-")[1] == "basic_bucket"):
						player.bucket_level_label.text = "Bucket water level: 00"
						player.bucket_level_label.position = Vector2(-560, -290)
						buying_bar.remove_item(item_index)
		else:
			print("Not enough money")
	buying_bar.deselect_all()
	buying_bar.release_focus()


func _onSelectedFromMachineBuyBar(item_index):
	if player.inventory_lock:
		inventoryFull.emit()
		machine_buy_bar.deselect_all()
		machine_buy_bar.release_focus()
		return
	var regex = RegEx.new()
	regex.compile("[0-9]*")
	var result = regex.search(machine_buy_bar.get_item_text(item_index))
	if result:
		if player.money >= int(result.get_string()):
			player.money -= int(result.get_string())
			grid.ChangeMoneroAmount.emit(player.money)
			#buying_bar.get_item_text(item_index).split("-")[1]]
			player.append_to_inventory(MachineOnHand.new(machine_buy_bar.get_item_text(item_index).split("-")[1]))
			
						# place it on your inventory now...
	machine_buy_bar.deselect_all()
	machine_buy_bar.release_focus()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.right_click.connect(_onSellRightClick)
	button.left_click.connect(_onSellLeftClick)
	buying_bar.visible = false
	buying_bar.item_selected.connect(_onSelectedFromBuyBar)
	machine_buy_bar.visible = false
	machine_buy_bar.item_selected.connect(_onSelectedFromMachineBuyBar)
	button.visible = false
	
	self.area_shape_entered.connect(_onMarketEnter)
	self.area_shape_exited.connect(_onMarketExit)

	buying_bar.add_item("15   -Empty Plastic Bag", preload("res://art/EmptyPlasticBag.png"), true)
	buying_bar.add_item("50   -sprinkler_mk2", preload("res://art/Sprinkler2.png"), true)
	buying_bar.add_item("50   -better_gloves", preload("res://art/Gloves2.png"), true)
	buying_bar.add_item("50   -better_hoe", preload("res://art/Hoe2.png"), true)
	buying_bar.add_item("10   -basic_bucket", preload("res://art/Balde.png"), true)
	buying_bar.add_item("75   -humidity_checker2", preload("res://art/Waterer2.png"), true)
	buying_bar.add_item("175  -humidity_checker3remote", preload("res://art/Waterer3Remote.png"))
	buying_bar.add_item("10   -sunflower_seeds_bag", preload("res://art/SunFlowerSeedsBagItem.png"), true)
	
	
	machine_buy_bar.add_item("100   -water_tank", preload("res://art/Machines/WaterTank.png"), true)
	machine_buy_bar.add_item("150   -aspersor_basico", preload("res://art/Machines/AutoWaterer1.png"), true)
	machine_buy_bar.add_item("250   -aspersor_a_presion", preload("res://art/Machines/AutoWaterer2.png"), true)
	machine_buy_bar.add_item("10   -pipe", preload("res://art/Pipe.png"), true)
	machine_buy_bar.add_item("20   -valve", preload("res://art/ClosedPipeValve.png"), true)
	machine_buy_bar.add_item("100  -humidity_checker1", preload("res://art/Waterer1Icon.png"), true)
	machine_buy_bar.add_item("150  -humidity_checker3", preload("res://art/Waterer3Icon.png"), true)
	var buy_text = Label.new()
	buy_text.text = "Buy!"
	buying_bar.add_child(buy_text)

	var sell_text = Label.new()
	sell_text.text = "Sell!"
