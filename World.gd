extends Node

export(Array) var camera_positions;


# Internal node references
onready var navigation_map = $NavigationMap;
onready var player = $Player;
onready var node2D = $Center;
onready var flag = $Flags;
onready var inventory = preload("res://Inventory.gd");
onready var pirateObj = preload("res://Pirate.tscn");
onready var item = preload("res://Item.tscn");
onready var data = get_node("/root/PlayerData");
onready var camera;
onready var global = get_node("/root/Global");
var current_menu;

var crewCount = 0;
var crew = [];
var ids = [];
#onready var menu = get_node("/root/MainMenu");
var MenuOption = "Start";

func _unhandled_input(event):
	if Input.is_action_pressed("right_click"):
		_calculate_new_path();
	pass

# Calculates a new path and gives to sidekick
func _calculate_new_path():
	if not current_menu == null:
		current_menu._player_moved_hide();
		current_menu = null;
	
	var path;
	path = navigation_map._get_path(player.position, node2D.get_global_mouse_position())
	# If we got a path...
	if path:
	
		# Remove the first point (it's where the sidekick is)
		path.remove(0)
		
		# Sets the sidekick's path
		player.path = path
		global.playWind();
	pass

func _on_Flag_current_menu_opened(menu):
	current_menu = menu;
	pass 

func _set_island_path(_path):
	var path;
	path = navigation_map._get_path(player.position, _path);
	print(path);
	# If we got a path...
	if path:
		# Remove the first point (it's where the sidekick is)
		path.remove(0)
		
		# Sets the sidekick's path
		player.path = path
		global.playWind();
	pass;

func _update_camera_limit(fragments):
	camera = get_node("MainCamera");
	camera.limit_bottom = camera_positions[fragments][3];
	pass;