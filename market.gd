extends Area2D

@onready var player = $"../Player"
@onready var buying_bar = $"Buying Bar"
@onready var selling_bar = $"Selling Bar"
@onready var machine_buy_bar = $"MachineBuy"
@onready var shape = $CollisionShape2D 
@onready var grid = $"../Grid"

func _onMarketEnter(area_rid, area, area_shape_index, local_shape_index):
	buying_bar.visible = true
	selling_bar.visible = true
	machine_buy_bar.visible = true
	
func _onMarketExit(area_rid, area, area_shape_index, local_shape_index):
	buying_bar.visible = false
	selling_bar.visible = false
	machine_buy_bar.visible = false

func _onSelectedFromBuyBar(item_index):
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
				player.append_to_inventory(ToolList.tool_list[buying_bar.get_item_text(item_index).split("-")[1]])
				if(buying_bar.get_item_text(item_index).split("-")[1] == "basic_bucket"):
					player.bucket_level_label.text = "Bucket water level: 00"
					player.bucket_level_label.position = Vector2(-560, -290)
					buying_bar.remove_item(item_index)
					print("Buying bucket")
		else:
			print("Not enough money")
	buying_bar.deselect_all()

func _onSelectedFromSellBar(item_index):
	var regex = RegEx.new()
	regex.compile("[0-9]*")
	var result = regex.search(selling_bar.get_item_text(item_index))
	if result:
		if player.inventory.has(ToolList.tool_list[selling_bar.get_item_text(item_index).split("-")[1]]):
			player.remove_n_from_inventory(ToolList.tool_list[selling_bar.get_item_text(item_index).split("-")[1]], 1)
			player.money += int(result.get_string())
			grid.ChangeMoneroAmount.emit(player.money)
	else:
		print("Not item")
	selling_bar.deselect_all()

func _onSelectedFromMachineBuyBar(item_index):
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
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buying_bar.visible = false
	buying_bar.item_selected.connect(_onSelectedFromBuyBar)
	selling_bar.visible = false
	selling_bar.item_selected.connect(_onSelectedFromSellBar)
	machine_buy_bar.visible = false
	machine_buy_bar.item_selected.connect(_onSelectedFromMachineBuyBar)
	
	self.area_shape_entered.connect(_onMarketEnter)
	self.area_shape_exited.connect(_onMarketExit)

	buying_bar.add_item("10   -Empty Plastic Bag", preload("res://art/EmptyPlasticBag.png"), true)
	buying_bar.add_item("50   -sprinkler_mk2", preload("res://art/Sprinkler2.png"), true)
	buying_bar.add_item("50   -better_gloves", preload("res://art/Gloves2.png"), true)
	buying_bar.add_item("50   -better_hoe", preload("res://art/Hoe2.png"), true)
	buying_bar.add_item("10   -basic_bucket", preload("res://art/Balde.png"), true)
	buying_bar.add_item("75   -humidity_checker2", preload("res://art/Waterer2.png"), true)
	buying_bar.add_item("175  -humidity_checker3remote", preload("res://art/Waterer3Remote.png"))
	
	selling_bar.add_item("10   -sprinkler", preload("res://art/Sprinkler.png"), true)
	selling_bar.add_item("20   -bolsa_de_pipas", preload("res://art/Bolsita10Pipas.png"), true)
	
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
	selling_bar.add_child(sell_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
