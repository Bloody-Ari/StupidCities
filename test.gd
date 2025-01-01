extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite = Sprite2D.new()
	sprite.texture = load("res://art/Machines/AutoWaterer1.png")
	add_child(sprite)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
