extends Sprite

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
onready var inventory = $Inventory;
onready var pirateObj = preload("res://Pirate.tscn");


func _ready():
	for i in range(10):
		crew.append(null);
	pass

func _input(event):
	if event.is_action_pressed("key_k") and crewCount < 10:
		_recruitPirate();
	if event.is_action_pressed("key_v"):
		if hudObj.visible == true:
			hudObj.visible = false;
		else:
			hudObj.visible = true;
			
	pass;

func _recruitPirate():
	var newPirate = pirateObj.instance();
	newPirate._set_tag(0);
	crew[crewCount] = newPirate;
	newPirate._initializePirate();
	newPirate._setId(crewCount);
	hudObj.add_child(newPirate);
	newPirate.position = slot_positions[crewCount];
	crewCount += 1;
	pass;

# Performed on each step
func _process(delta):
	
	# Only do stuff if we have a current path
	if path:

		# The next point is the first member of the path array
		var target = path[0];

		# Determine direction in which sidekick must move
		var direction = (target - position).normalized();

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
	print("saving...");
	var save_game = File.new();
	save_game.open("res://savegame.save", File.WRITE);
	var ship_dict = {
		"ship" : "starterShip",
		"crewCount" : crewCount
	}
	
	save_game.store_line(to_json(ship_dict));
	
	for i in crewCount:
		var crew_dict = crew[i]._savePirate();
		save_game.store_line(to_json(crew_dict));
		
	save_game.close();
	print("saved");
	pass;

func _readData():
	
	var save_game = File.new();
	if not save_game.file_exists("res://savegame.save") and crewCount == 0:
		print("file does not exists");
		return;
		
	save_game.open("res://savegame.save", File.READ)
	
	var first_line =  parse_json(save_game.get_line());
	var current_line = parse_json(save_game.get_line())
	while not save_game.eof_reached():
		var newPirate = pirateObj.instance();
		crew[crewCount] = newPirate;
		print("---------");
		print(crewCount);
		print("---------");
		
		newPirate._setData(crewCount, current_line["tag"], current_line["hp"], current_line["attack"], current_line["defense"], current_line["speed"], current_line["mining"], current_line["cooking"]);
		hudObj.add_child(newPirate);
		newPirate.position = slot_positions[crewCount];
		crewCount += 1;
		current_line = parse_json(save_game.get_line())
	save_game.close();
	pass;

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _get_crew():
	return crew;
	pass;
func _get_pirate(index):
	return crew[index];
	pass;

func _on_SaveButton_pressed():
	_saveData();
	pass;
func _on_LoadButton_pressed():
	_readData();
	pass;
func _on_Island_send_player_reward(player_reward):
	inventory._insert_item(player_reward);
	pass ;
func _get_inventory():
	return inventory;
	pass;



