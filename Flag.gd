extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var menuButton = $Button;
var islandMenu;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	islandMenu = get_node("IslandMenu/IslandMenu");
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Button_pressed():
	#window.popup();
	islandMenu.rect_position.x = position.x - (islandMenu.rect_size.x/2);
	islandMenu.rect_position.y = position.y - (islandMenu.rect_size.y/2);
	islandMenu.show()
	pass 
func _on_Fechar_pressed():
	islandMenu.hide()
	pass
