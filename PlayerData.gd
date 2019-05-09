extends Node2D

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
		get_tree().change_scene("res://BattleScene.tscn")
	pass;

func _test():
	var ids = [0,1,2];
	battleManager._instanciate_player_pirates(ids);
	pass;

func _recruitPirate():
	if crewCount < 10:
		var newPirate = pirateObj.instance();
		newPirate._set_tag(0);
		crew[crewCount] = newPirate;
		newPirate._initializePirate();
		newPirate._setId(crewCount);
		player._position_pirate(newPirate);
		crewCount += 1;
		_saveData();
	pass;

func _saveData():
	print("saving...");
	var save_game = File.new();
	
	save_game.open("res://savegame.json", File.WRITE);
	
	var ship_dict = {
		"shipType" : "starterShip",
		"crewCount" : crewCount
	}
	
	var json_data = {"ship": ship_dict}
	
	for i in crewCount:
		json_data[i] = crew[i]._savePirate();
	
	save_game.store_line(to_json(json_data));
		
	save_game.close();
	print("saved");
	pass;

func _readData():
	var save_game = File.new();
	if not save_game.file_exists("res://savegame.json") and crewCount == 0:
		print("file does not exists");
		return;
		
	save_game.open("res://savegame.json", File.READ)
	
	var current_line =  parse_json(save_game.get_line());
	
	crewCount = current_line["ship"]["crewCount"];
	
	for i in range(crewCount):
		var newPirate = pirateObj.instance();
		crew[i] = newPirate;
		newPirate._setData(i, current_line[str(i)]["tag"], current_line[str(i)]["hp"], current_line[str(i)]["maxHp"], current_line[str(i)]["attack"], current_line[str(i)]["defense"], current_line[str(i)]["speed"], current_line[str(i)]["mining"], current_line[str(i)]["cooking"]);
		player._position_pirate(newPirate);
		print("---------");
		print(i);
		print("---------");
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
