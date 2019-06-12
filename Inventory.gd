extends Node

const INVENTORY_SIZE = 25

var inventory = {};

func _insert_item(item):
	
	if inventory.has(item._get_name()): 
		var _item_list = inventory[item._get_name()];
		_item_list.push_front(item); 
	elif  inventory.keys().size() < INVENTORY_SIZE:
		var _item_list = [];
		_item_list.push_front(item); 
		inventory[item._get_name()] = _item_list;
	
	#if inventory.has(item._get_name()): #Checking if the inventory already has one item of the same type
	#	var _item_list = inventory[item._get_name()];
	#	_item_list.push_front(item); #Adding the new object to the list
	#elif  inventory.keys().size() < INVENTORY_SIZE:#If the inventory can add a new item
	#	var _item_list = []; #Creating a new slot for the item
	#	_item_list.push_front(item); #Adding the new object to the list
	#	inventory[item._get_name()] = _item_list;
	pass;

func _remove_item(item, quantity):
	if inventory.has(item):
		var _item = inventory[item];
		for i in range(quantity):
			_item.pop_front();
		if inventory[item].size() <= 0:
			inventory.erase(item);
	else:
		print("item not found");
	pass;

func _get_keys():
	return inventory.keys();
	pass;

func _get_item_count(key):
	if inventory.has(key):
		var _item_list = inventory[key];
		return _item_list.size();
	else:
		return 0;
	pass;

func _get_item(key):
	if inventory.has(key):
		return inventory[key][0];
	else:
		return 0;
	pass;

func _get_item_path(key):
	if inventory.has(key):
		var _item = inventory[key];
		return _item[0]._get_stat("path");
	else:
		return 0;