extends Node2D

export(int) var island_id;

signal current_menu_opened(menu);

export(Vector2) var path;
onready var global = get_node("/root/Global");
onready var menuButton = $Button;
onready var player = get_tree().get_root().get_node("World/Player");
onready var world = get_parent().get_parent().get_parent();
onready var camera = get_tree().get_root().get_node("World/MainCamera");
onready var inventory_camera = get_tree().get_root().get_node("World/InventoryCamera");
onready var inventory_screen = get_tree().get_root().get_node("World/InventoryCamera/InventoryScreen");

var islandMenu;
var player_inside;

func _ready():
	player_inside = false;
	islandMenu = get_node("IslandMenu/IslandMenu");
	
	if !global._get_island_state(island_id):
		menuButton.visible = false;
		menuButton.disabled = true;
		get_node("IslandMenu/IslandMenu")._set_defeated_state();
	pass;

func _process(delta):
	pass

func _on_Button_pressed():
	if player_inside:
		islandMenu.rect_position.x = position.x - (islandMenu.rect_size.x/2);
		islandMenu.rect_position.y = position.y - (islandMenu.rect_size.y/2);
		global.playIslandMenuSound();
		islandMenu.show();
		menuButton.visible = false;
		emit_signal("current_menu_opened", islandMenu);
		camera.follow(self);
	else:
		world._set_island_path(path);
	pass 

func _on_Area2D_area_entered(area):
	if area.name == "PlayerArea2D":
		player_inside = true;
	pass
	
func _on_Area2D_area_exited(area):
	if area.name == "PlayerArea2D":
		player_inside = false;
		if global._get_island_state(island_id):
			menuButton.visible = true;
	pass

func _on_InventoryButton_pressed():
	inventory_screen.visible = true;
	inventory_camera._set_current(true); 
	player._set_move(false);
	pass
	
func _on_CloseInventoryButton_pressed():
	inventory_screen.visible = false;
	camera._set_current(true); 
	player._set_move(true);
	pass

func _on_StartButton_pressed():
	 _on_InventoryButton_pressed();

func _change_state():
	global._set_island_state(island_id, false);
	menuButton.visible = false;
	pass;

func _get_island_id():
	return island_id;
	pass;
