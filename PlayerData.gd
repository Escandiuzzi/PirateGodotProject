extends Sprite

var crewCount = 0;
var crew = [];

onready var hudObj = get_node("HUD");
onready var inventory = $Inventory;
onready var pirateObj = preload("res://Pirate.tscn");
onready var battleManager = get_tree().get_root().get_node("BattleManager");
onready var player = get_tree().get_root().get_node("World/Player");

func _ready():
	for i in range(10):
		crew.append(null);
	pass

func _input(event):
	if event.is_action_pressed("key_b"):
		var test = [
			crew[0],
			crew[1],
			crew[2]
		];
		battleManager._initializeBattle(3, 3, test);
		get_tree().change_scene("res://BattleScene.tscn")
	pass;

func _recruitPirate():
	if crewCount < 10:
		var newPirate = pirateObj.instance();
		newPirate._set_tag(0);
		crew[crewCount] = newPirate;
		newPirate._initializePirate();
		newPirate._setId(crewCount);
		self.add_child(newPirate);
		#newPirate.position = slot_positions[crewCount];
		crewCount += 1;
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
		#newPirate.position = slot_positions[crewCount];
		crewCount += 1;
		current_line = parse_json(save_game.get_line())
	save_game.close();
	pass;

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
func _receive_player_reward(player_reward):
	inventory._insert_item(player_reward);
	pass ;
func _get_inventory():
	return inventory;
	pass;


