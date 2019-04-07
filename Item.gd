extends Node2D

var id;
var item_name;
var type;
var heal;
var damage;
var durability;
var combinations;

func _read_json_data(index):
	var items_file = File.new();
	
	if not items_file.file_exists("res://items.save"):
		print("file does not exists");
		return;
		
	items_file.open("res://items.save", File.READ)
	
	var data = {};
	
	data = parse_json(items_file.get_as_text());
	id = index;
	item_name = data[str(index)]["name"];
	type = data[str(index)]["type"];
	heal = data[str(index)]["heal"];
	damage = data[str(index)]["damage"];
	durability = data[str(index)]["durability"];
	combinations = data[str(index)]["combinations"];
	
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