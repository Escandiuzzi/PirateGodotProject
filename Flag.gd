extends Node2D

onready var menuButton = $Button;
var islandMenu;
var player_inside;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	player_inside = false;
	islandMenu = get_node("IslandMenu/IslandMenu");
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Button_pressed():
	#window.popup();
	if player_inside:
		islandMenu.rect_position.x = position.x - (islandMenu.rect_size.x/2);
		islandMenu.rect_position.y = position.y - (islandMenu.rect_size.y/2);
		islandMenu.show()
		get_node("../..")._on_Flag_On_Menu(true);
	pass 

func _on_Fechar_pressed():
	islandMenu.hide()

	pass

func _on_Area2D_area_entered(area):
	if area.name == "PlayerArea2D":
		player_inside = true;
	pass
	
func _on_Area2D_area_exited(area):
	if area.name == "PlayerArea2D":
		player_inside = false;
	pass
