extends Node2D

@onready var play_button = $FreePlayButton
@onready var tutorial_button = $TutorialButton
@onready var toggle_fullscreen_button = $ToggleFullScreen
@onready var exit_button = $ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.button_up.connect(func():
		get_tree().change_scene_to_file("res://main.tscn"))
	tutorial_button.button_up.connect(func():
		get_tree().change_scene_to_file("res://tutorial.tscn"))
	exit_button.button_up.connect(func():
		get_tree().quit())
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
