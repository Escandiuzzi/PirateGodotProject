extends Node2D

var _name;
var _damage;
var _heal;
var _range;
var _energy;

func _get_data(index, subindex):
	var json = File.new();
	if not json.file_exists("res://special.json"):
		print("file does not exists");
		return;
		
	json.open("res://special.json", File.READ)
	
	var data = {};
	
	data = parse_json(json.get_as_text());

	_name = data[index][str(subindex)]["name"];
	_damage = data[index][str(subindex)]["damage"];
	_heal = data[index][str(subindex)]["heal"];
	_range = data[index][str(subindex)]["range"];
	_energy = data[index][str(subindex)]["energy"];
	pass;

func _get_stat(type):
	if type == "name":
		return _name;
	elif type == "damage":
		return _damage;
	elif type == "heal":
		return _heal;
	elif type == "range":
		return _range;
	elif type == "energy":
		return _energy;
	pass;