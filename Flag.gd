extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var window = get_node("Button/Window");
onready var menuButton = $Button;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Button_pressed():
	window.popup();
	window._change_position(position)
	pass # replace with function body
