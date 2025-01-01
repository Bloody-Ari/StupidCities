extends Node2D
class_name Machine

var machine_name: String
var texture: Texture
var resource: String # "Water"
var fuel: String # "Electricity", "Oil", "Gas"
var description: String
var level: int
var shape = AnimatedSprite2D.new()
var area = Area2D.new()
var collision_shape = CollisionShape2D.new()

func _init(_name, _descriptcion, _texture, _level, _resource, _fuel):
	name = _name
	description = _descriptcion
	texture = _texture
	
	var animation = SpriteFrames.new()
	animation.add_frame("Running", texture)
	shape.set_animation("Running")
	add_child(shape)
	
	level = _level
	resource = _resource
	fuel = _fuel
	

func run(cords: Vector2, game_grid: GameGrid):
	print("Can I extend functions later???")
	pass
