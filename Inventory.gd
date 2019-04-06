extends Node

var inventory = {};

func _insert_item(item):
	if inventory.has(item._get_name()):
		var _item_list = inventory[item._get_name()];
		_item_list.push_front(item);
	else:
		var _item_list = [];
		_item_list.push_front(item);
		inventory[item._get_name()] = _item_list;
	pass;

func _remove_item(item):
	if inventory.has(item._get_name()):
		var _item_list = inventory[item._get_name()];
		_item_list.remove(item);
	else:
		print("item not found");
	pass;

func _get_keys():
	return inventory.keys();
	pass;

func _get_item_count(key):
	var _item_list = inventory[key];
	return _item_list.size();
	pass;
