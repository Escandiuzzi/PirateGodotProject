extends Node2D

signal current_menu_opened(menu);


onready var menuButton = $Button;
onready var player = get_tree().get_root().get_node("World/Player");

var islandMenu;
var player_inside;

func _ready():
	player_inside = false;
	islandMenu = get_node("IslandMenu/IslandMenu");
	pass

func _process(delta):
	pass

func _on_Button_pressed():
	if player_inside:
		islandMenu.rect_position.x = position.x - (islandMenu.rect_size.x/2);
		islandMenu.rect_position.y = position.y - (islandMenu.rect_size.y/2);
		islandMenu.show();
		menuButton.visible = false;
		emit_signal("current_menu_opened", islandMenu);
	pass 

func _on_Area2D_area_entered(area):
	if area.name == "PlayerArea2D":
		player_inside = true;
	pass
	
func _on_Area2D_area_exited(area):
	if area.name == "PlayerArea2D":
		player_inside = false;
		menuButton.visible = true;
	pass