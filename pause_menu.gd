extends ColorRect

@onready var back_to_game_button = $VBoxContainer/BackToGameButton
@onready var full_screen_button = $VBoxContainer/FullScreenButton
@onready var main_menu_button = $VBoxContainer/MainMenuButton
@onready var quit_button = $VBoxContainer/QuitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_to_game_button.button_up.connect(func():
		get_tree().paused = false
		visible = false
	)
	
	
	# add confirmation
	main_menu_button.button_up.connect(func():
		get_tree().paused = !get_tree().paused
		get_tree().change_scene_to_file("res://main_screen.tscn"))
	# add confirmation
	quit_button.button_up.connect(func():
		get_tree().quit())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
