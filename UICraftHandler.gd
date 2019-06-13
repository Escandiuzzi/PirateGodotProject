extends Node2D

onready var item = preload("res://Item.tscn");

onready var consumables_buttons = [
	get_parent().get_node("Layer 1/Slot1Button"),
	get_parent().get_node("Layer 1/Slot2Button"),
	get_parent().get_node("Layer 1/Slot3Button"),
	get_parent().get_node("Layer 1/Slot4Button"),
	get_parent().get_node("Layer 1/Slot5Button"),
	get_parent().get_node("Layer 1/Slot6Button"),
	get_parent().get_node("Layer 1/Slot7Button"),
	get_parent().get_node("Layer 1/Slot8Button"),
	get_parent().get_node("Layer 1/Slot9Button"),
	get_parent().get_node("Layer 1/Slot10Button"),
	get_parent().get_node("Layer 1/Slot11Button"),
	get_parent().get_node("Layer 1/Slot12Button")
];

onready var materials_buttons = [
	get_parent().get_node("Layer 2/Slot1Button"),
	get_parent().get_node("Layer 2/Slot2Button"),
	get_parent().get_node("Layer 2/Slot3Button"),
	get_parent().get_node("Layer 2/Slot4Button"),
	get_parent().get_node("Layer 2/Slot5Button"),
	get_parent().get_node("Layer 2/Slot6Button"),
	get_parent().get_node("Layer 2/Slot7Button"),
];

onready var layers = [
	get_parent().get_node("Layer 1"),
	get_parent().get_node("Layer 2")
];

onready var ingredients_panel = get_parent().get_node("IngredientsPanel");
onready var ingredients_text = get_parent().get_node("IngredientsPanel/IngredientsText");
onready var inventory_text = get_parent().get_node("InventoryPanel/InventoryText");

onready var data = get_tree().get_root().get_node("/root/PlayerData");

func _ready():
	_initialize_buttons();
	_generate_itens();
	_check_can_craft(consumables_buttons);
	_check_can_craft(materials_buttons);
	_get_players_inventory();
	pass;


func _initialize_buttons():
	
	var recipes_file = File.new();
	
	if not recipes_file.file_exists("res://recipes.json"):
		print("file does not exists");
		return;
		
	recipes_file.open("res://recipes.json", File.READ)
	
	var data = {};
	
	data = parse_json(recipes_file.get_as_text());
	
	for i in range(consumables_buttons.size()):
		consumables_buttons[i].text = data["Consumable"][str(i)]["name"];
		consumables_buttons[i]._set_name(data["Consumable"][str(i)]["name"]);
		consumables_buttons[i]._set_ingredients(data["Consumable"][str(i)]["ingredients"]);
		consumables_buttons[i]._set_path(data["Consumable"][str(i)]["path"]);
	
	for i in range(materials_buttons.size()):
		materials_buttons[i].text = data["Material"][str(i)]["name"];
		materials_buttons[i]._set_name(data["Material"][str(i)]["name"]);
		materials_buttons[i]._set_ingredients(data["Material"][str(i)]["ingredients"]);
		materials_buttons[i]._set_path(data["Material"][str(i)]["path"]);
	
	recipes_file.close();
	pass;
	
func _on_SlotButton_mouse_entered(extra_arg_0):
	
	if layers[0].visible == true:
		ingredients_panel.visible = true;
		var ingredients = consumables_buttons[extra_arg_0]._get_ingredients();
		var keys = ingredients.keys();
		
		for i in range(keys.size()):
			ingredients_text.text += keys[i] + " x" + str(ingredients[keys[i]]) + "\n";
			
	if layers[1].visible == true:
		ingredients_panel.visible = true;
		var ingredients = materials_buttons[extra_arg_0]._get_ingredients();
		var keys = ingredients.keys();
		
		for i in range(keys.size()):
			ingredients_text.text += keys[i] + " x" + str(ingredients[keys[i]]) + "\n";
			
	pass;

func _on_SlotButton_mouse_exited():
	ingredients_text.text = "";
	ingredients_panel.visible = false;
	pass;

func _get_players_inventory():
	
	var inventory = data._get_inventory();
	var keys = inventory._get_keys();
	inventory_text.text ="";
	for i in range(keys.size()):
		inventory_text.text += str(inventory._get_item_count(keys[i]));
		inventory_text.text += "x "
		inventory_text.text += keys[i];
		inventory_text.text += "\n";
	pass;

func _check_can_craft(array):
	
	var inventory = data._get_inventory();
	var keys = inventory._get_keys();
	
	for i in range(array.size()):
		var can_craft = true;
		var ingredients = array[i]._get_ingredients();
		var i_keys = ingredients.keys();
		
		for j in range (i_keys.size()):
			if inventory._get_item_count(i_keys[j]) >= ingredients[i_keys[j]]:
				var a;
			else:
				array[i].disabled = true;
				break;
	
	pass;
func _generate_itens():
	for i in range(20):
		#/////////////////////////////////////////
		var randReward = randi() % 3; 
		var rarity = randi() % 100;
		var _item = item.instance();
		_item._read_json_data(randReward, "Sul", "Common", "Consumable");
		data._receive_player_reward(_item);
	pass;


func _on_SlotButton_pressed(extra_arg_0):
	
	if layers[0].visible == true:
		var ingredients = consumables_buttons[extra_arg_0]._get_ingredients();
		var i_keys = ingredients.keys();
		
		for i in range(i_keys.size()):
			data._remove_item(i_keys[i], ingredients[i_keys[i]]);
		var crafted_item = item.instance();
		var path =  consumables_buttons[extra_arg_0]._get_path();
		crafted_item._read_json_data(path[3], path[0], path[2], path[1]);
		data._receive_player_reward(crafted_item);
		_get_players_inventory();
	else:
		var ingredients = materials_buttons[extra_arg_0]._get_ingredients();
		var i_keys = ingredients.keys();
		
		for i in range(i_keys.size()):
			data._remove_item(i_keys[i], ingredients[i_keys[i]]);
		var crafted_item = item.instance();
		var path =  materials_buttons[extra_arg_0]._get_path();
		crafted_item._read_json_data(path[3], path[0], path[2], path[1]);
		data._receive_player_reward(crafted_item);
		_get_players_inventory();
	pass


func _on_LayerButton_pressed(extra_arg_0):
	if extra_arg_0 == 0:
		layers[0].visible = false;
		layers[1].visible  = true;
	else:
		layers[0].visible  = true;
		layers[1].visible  = false;
	pass;


func _on_ReturnButton_pressed():
	get_tree().change_scene("res://World.tscn")
	pass;
