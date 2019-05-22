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

func _input(event):
	if event.is_action_pressed("key_k") and crewCount < 10:
		data._recruitPirate();
	if event.is_action_pressed("key_v"):
		if hudObj.visible == true:
				hudObj.visible = false;
		else:
			hudObj.visible = true;
			
	pass;

# Performed on each step
func _process(delta):
	
	# Only do stuff if we have a current path
	if path:

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
