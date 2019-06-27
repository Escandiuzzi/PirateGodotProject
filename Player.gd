extends Node2D

# Speed at which the sidekick will move

export(int) var movement_speed;

# How close the sidekick must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 5;

# Path that the sidekick must follow - undefined by default
var path;
var crewCount = 0;
var crew = [];

var slot_positions = [
Vector2(-450, 0), 
Vector2(-350, 0),
Vector2(-250, 0),
Vector2(-150, 0), 
Vector2(-50, 0),
Vector2(50, 0),
Vector2(150, 0),
Vector2(250, 0),
Vector2(350, 0),
Vector2(450, 0)];

onready var hudObj = get_node("HUD");
onready var data = get_tree().get_root().get_node("/root/PlayerData");
onready var sprite = $"Player Sprite";
onready var global = get_node("/root/Global");
onready var camera = $Camera2D;


var move;
var current_pirate = null;


func _ready():
	global.playBackground1();
	move = true;
	if global.getGame() == true:
		data._recruitPirate(0);
	else:
		data._readData(0);
	
	position = global._get_player_coordinates();
	
	get_tree().get_root().get_node("World")._update_camera_limit(data._get_map_fragment());
	

func _input(event):
	if event.is_action_pressed("key_k") and crewCount < 10:
		data._recruitPirate(0);
	if event.is_action_pressed("key_v"):
		if hudObj.visible == true:
				hudObj.visible = false;
		else:
			hudObj.visible = true;
	if event.is_action_pressed("key_b"):
		get_tree().change_scene("res://CraftingStation.tscn")
	pass;

# Performed on each step
func _process(delta):
	
	# Only do stuff if we have a current path
	if path and move:

		# The next point is the first member of the path array
		var target = path[0];

		# Determine direction in which sidekick must move
		var direction = (target - position).normalized();
		
		sprite.look_at(target);
		
		# Move sidekick
		position += direction * movement_speed * delta;

		# If we have reached the point...
		if position.distance_to(target) < POINT_RADIUS:

			# Remove first path point
			path.remove(0);

			# If we have no points left, remove path
			if path.size() == 0:
				path = null;
	pass;

func _saveData():
	data._saveData();
	pass;

func _readData():
	data._readData(0);
	pass;

func _get_crew():
	return data._get_crew();
	pass;

func _get_pirate(index):
	return  data._get_pirate(index);
	pass;

func _on_SaveButton_pressed():
	_saveData();
	pass;

func _on_LoadButton_pressed():
	_readData();
	pass;
	

func _on_Island_send_player_reward(player_reward):
	data._receive_player_reward(player_reward);
	pass;

func _get_inventory():
	return data._get_inventory();
	pass;

func _position_pirate(pirate_obj):
	hudObj.add_child(pirate_obj);
	pirate_obj.position = slot_positions[crewCount];
	crewCount +=1;
	pass;

func _clear_path():
	path = null;
	pass;
	
func _set_move(value):
	move = value;
	pass;

func _set_current_pirate(current):
	current_pirate = current;
	pass;

func _on_UIInputHandler_on_item_selected(item_selected):
	var type = item_selected._get_stat("type");
	if type == "consumable":
		var heal = item_selected._get_stat("heal");
		var damage = item_selected._get_stat("damage");
		var durability = item_selected._get_stat("durability");
		current_pirate._set_hp(current_pirate._get_hp() + heal);
	elif type == "weapon":
		var damage = item_selected._get_stat("damage");
		var durability =  item_selected._get_stat("durability");
		current_pirate._set_weapon(item_selected);
		current_pirate._set_atk_bonus(damage);
	elif type == "armor":
		var heal = item_selected._get_stat("heal");
		var durability =  item_selected._get_stat("durability");
		current_pirate._set_shield(item_selected);
		current_pirate._set_def_bonus(heal);
	current_pirate = null;
	pass;


func _on_Island_on_pirate_selected(pirate):
	crew = data._get_crew();
	current_pirate = crew[pirate];
	pass 
