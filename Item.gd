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
	var current_line = parse_json(items_file.get_line());
	var item = current_line[str(index)];
	
	id = index;
	item_name = item["name"];
	type = item["type"];
	heal = item["heal"];
	damage = item["damage"];
	durability = item["durability"];
	combinations = item["combinations"];
	
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