extends Sprite

# Speed at which the sidekick will move

export(int) var MOVEMENT_SPEED;

# How close the sidekick must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 5;

# Path that the sidekick must follow - undefined by default
var path;
var crewCount = 0;
var crew = [];


onready var pirateObj = preload("res://Pirate.tscn");

func _ready():
	for i in range(10):
		crew.append(null);
	pass

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo and crewCount < 10:
		_recruitPirate();
	if ev is InputEventKey and ev.scancode == KEY_S and not ev.echo:
		_saveData();
	if ev is InputEventKey and ev.scancode == KEY_R and not ev.echo:
		_readData();
	pass;

func _recruitPirate():
	var newPirate = pirateObj.instance();
	var newPos = Vector2(position.x - 33, position.y + (crewCount * 54));
	newPirate.position = newPos;
	crew[crewCount] = newPirate;
	newPirate._initializePirate();
	newPirate._setId(crewCount);
	crewCount += 1;
	add_child(newPirate);
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
		position += direction * MOVEMENT_SPEED * delta;

		# If we have reached the point...
		if position.distance_to(target) < POINT_RADIUS:

			# Remove first path point
			path.remove(0);

			# If we have no points left, remove path
			if path.size() == 0:
				path = null;

	pass;

#func _saveData():
	#var save_nodes = get_tree().get_nodes_in_group("Persist");
	#for i in save_nodes:
	#	var a;
	#pass;

func _saveData():
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
	pass;

func _readData():
	var save_game = File.new();
	if not save_game.file_exists("res://savegame.save") and crewCount == 0:
		print("file does not exists");
		return;
		
	save_game.open("res://savegame.save", File.READ)
	
	#var first_line =  parse_json(save_game.get_line());
	var current_line = parse_json(save_game.get_line())
	while not save_game.eof_reached():
		var newPirate = pirateObj.instance();
		var newPos = Vector2(position.x - 33, position.y + (crewCount * 54));
		newPirate.position = newPos;
		crew[crewCount] = newPirate;
		print("---------");
		print(crewCount);
		print("---------");
		newPirate._setId(crewCount);
		newPirate._setData(crewCount, current_line["mining"], current_line["battle"], current_line["cooking"]);
		crewCount += 1;
		add_child(newPirate);
		current_line = parse_json(save_game.get_line())
	save_game.close();


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_SaveButton_pressed():
	_saveData();
	pass # replace with function body


func _on_LoadButton_pressed():
	_readData();
	pass # replace with function body
