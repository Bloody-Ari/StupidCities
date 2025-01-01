extends Resource
class_name ToolList

# later on this should be on a file and the game should only load them as needed?

static var tool_list = {
	"hoe" : Hoe.new(
		"Hoe",
		"Powels a tile to allow you to plant seeds!",
		preload("res://art/Hoe.png"),
		1
	),
	"gloves" : Gloves.new(
		"Gloves",
		"Allows you to pickup things from a tile!",
		preload("res://art/Gloves.png"),
		1
	),
	"sprinkler" : Sprinkler.new(
		"Sprinkler",
		"Just a sprinkler, you have to fill it from time to time and don't let it's water rot!",
		preload("res://art/Sprinkler.png"),
		1
	),
	"sunflower_seeds_bag" : SunflowerSeedsBag.new(
		"Sunflower Seeds Bag",
		"Plant this seed and take care of it to grow a tall and healthy sunflower!",
		preload("res://art/SunFlowerSeedsBagItem.png"),
		1,
		5
	),
	"sprinkler_mk2" : Sprinkler.new(
		"Sprinkler Mk2",
		"A better sprinkler, holds more water and let's you water more tiles at a time",
		preload("res://art/Sprinkler2.png"),
		2
	),
	"plastic_bag" : EmptyPlasticBag.new(
		"Empty Plastic Bag",
		"A bag to store things... maybe a machine could help",
		preload("res://art/EmptyPlasticBag.png"),
		1,
		5
	),
	"bolsa_de_pipas" : Tool.new(
		"Bolsa de Pipas", 
		"Una bolsa con 10 semillas de girasol empaquetadas", 
		preload("res://art/Bolsita10Pipas.png"), 
		1),
	"better_gloves" : Gloves.new(
		"Guantes grandes",
		"Guantes mas grandes y resistenes",
		preload("res://art/Gloves2.png"),
		2
	),
	"better_hoe" : Hoe.new(
		"Better Hoe",
		"Just that, a hoe but better. What did you expect?",
		preload("res://art/Hoe2.png"),
		2
	),
	"basic_bucket" : Bucket.new(
		"Balde",
		"",
		preload("res://art/Balde.png"),
		1
	)
}
