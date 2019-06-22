extends Node2D

var crewCount = 0;
var crew = [];
var ids = [];

var map_fragments = 0;

onready var hudObj = get_node("HUD");
onready var inventory = $Inventory;
onready var pirateObj = preload("res://Pirate.tscn");
onready var battleScene;
onready var player;
onready var item = preload("res://Item.tscn");

func _selected_pirates(_ids):
	for i in range(_ids.size()):
		if _ids[i] != null:
			ids.append(null);
			ids[i] = _ids[i];
	pass;

func _request_player_pirates():
	battleScene = get_tree().get_root().get_node("BattleScene");
	battleScene._instanciate_player_pirates(ids);
	pass;

func _recruitPirate(index):
	if crewCount < 10:
		crew.append(null);
		var newPirate = pirateObj.instance();
		newPirate._set_tag(0);
		crew[crewCount] = newPirate;
		newPirate._initializePirate();
		newPirate._setId(crewCount);
		crewCount += 1;
		_saveData();
		
		if index == 0:
			player = get_tree().get_root().get_node("World/Player");
			player._position_pirate(newPirate);
	pass;

func _saveData():
	print("saving...");
	var save_game = File.new();
	
	save_game.open("res://savegame.json", File.WRITE);
	
	var ship_dict = {
		"shipType" : "starterShip",
		"crewCount" : crewCount,
		"fragments" : map_fragments
	}
	
	var json_data = {"ship": ship_dict}
	for i in crewCount:
		json_data[i] = crew[i]._savePirate();
	
	save_game.store_line(to_json(json_data));
		
	save_game.close();
	print("saved");
	_save_inventory_data();
	pass;

func _readData(id):
	crew.clear();
	var save_game = File.new();
	if not save_game.file_exists("res://savegame.json") and crewCount == 0:
		print("file does not exists");
		return;
		
	save_game.open("res://savegame.json", File.READ)
	
	var current_line =  parse_json(save_game.get_line());
	
	crewCount = current_line["ship"]["crewCount"];
	map_fragments = current_line["ship"]["fragments"];
	for i in range(crewCount):
		crew.append(null);
		var newPirate = pirateObj.instance();
		crew[i] = newPirate;
		newPirate._setData(i, current_line[str(i)]["tag"], current_line[str(i)]["hp"], current_line[str(i)]["maxHp"], current_line[str(i)]["energy"],  current_line[str(i)]["maxEnergy"], current_line[str(i)]["attack"], current_line[str(i)]["mining"], current_line[str(i)]["cooking"], current_line[str(i)]["special"], current_line[str(i)]["atkBonus"], current_line[str(i)]["weaponPath"], current_line[str(i)]["weaponDurability"], current_line[str(i)]["defBonus"], current_line[str(i)]["shieldPath"], current_line[str(i)]["shieldDurability"]);
		if id == 0:
			player = get_tree().get_root().get_node("World/Player");
			player._position_pirate(newPirate);
		
	save_game.close();
	
	_read_inventory_data();
	
	pass;

func _save_inventory_data():
	var save_inventory = File.new();
	
	save_inventory.open("res://invetorysave.json", File.WRITE);
	
	var json_data = {"Inventory Size":inventory._get_keys().size()};
	
	var inventory_keys = inventory._get_keys();
	
	for i in inventory_keys.size():
		var item = {"name": inventory_keys[i], "quantity": inventory._get_item_count(inventory_keys[i]), "path" : inventory._get_item_path(inventory_keys[i])}
		json_data[i] = item;			
	
	save_inventory.store_line(to_json(json_data));
		
	save_inventory.close();
	pass;

func _read_inventory_data():
	var inventory_save = File.new();
	if not inventory_save.file_exists("res://invetorysave.json"):
		print("file does not exists");
		return;
		
	inventory_save.open("res://invetorysave.json", File.READ)
	
	var current_line =  parse_json(inventory_save.get_line());
	
	var pos = 0;
	
	for i in range(current_line["Inventory Size"]):
		var _item = item.instance();
		for i in range(current_line[str(pos)]["quantity"]):
			_item._read_json_data(current_line[str(pos)]["path"][3], current_line[str(pos)]["path"][0], current_line[str(pos)]["path"][2], current_line[str(pos)]["path"][1]);
			inventory._insert_item(_item);
		pos+= 1;
	inventory_save.close();
	pass;


func _update_crew(pirate):
	crew[pirate._get_id()] = pirate;
	_saveData();
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
	_readData(0);
	pass;

func _remove_pirate(pirate):
	crew.erase(pirate);
	crewCount -= 1;
	pass;

func _receive_player_reward(player_reward):
	inventory._insert_item(player_reward);
	pass;

func _remove_item(item, quantity):
	inventory._remove_item(item, quantity);
	pass;

func _get_inventory():
	return inventory;
	pass;

func print_crew():
	for i in range(crewCount):
		print(crew[i]);
	pass;

func _add_map_fragment():
	map_fragments += 1;
	pass;

func _get_map_fragment():
	return map_fragments;
	pass;