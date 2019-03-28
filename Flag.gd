extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var window = get_node("Button/Window");
onready var menuButton = $Button;
var MenuIlha

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	MenuIlha = get_node("MenuIlha")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Button_pressed():
	#window.popup();
	MenuIlha.show()
	var a = Vector2(0,0)
	MenuIlha.rect_position = position
	print("criei popup")
	#MenuIlha._change_position(position)
	#window._change_position(position)
	pass # replace with function body
func _on_Fechar_pressed():
	MenuIlha.hide()
	pass
