extends Node2D

var id;
var item_name;
var type;
var heal;
var damage;
var durability;
var combinations;

func _read_json_data(index, region, rarity):
	var items_file = File.new();
	
	if not items_file.file_exists("res://items.json"):
		print("file does not exists");
		return;
		
	items_file.open("res://items.json", File.READ)
	
	var data = {};
	
	data = parse_json(items_file.get_as_text());
	id = index;
	item_name = data[region][rarity][str(index)]["name"];
	type = data[region][rarity][str(index)]["type"];
	heal = data[region][rarity][str(index)]["heal"];
	damage = data[region][rarity][str(index)]["damage"];
	durability = data[region][rarity][str(index)]["durability"];
	combinations = data[region][rarity][str(index)]["combinations"];
	
	items_file.close();
	pass;

func _print_data():
	
	print("#################");
	print(id);
	print(item_name);
	print(type);
	print(heal);
	print(damage);
	print(durability);
	print(combinations);
	print("#################");
	
	pass;
	
func _get_id():
	return id;
	pass;

func _get_name():
	return item_name;
	pass;