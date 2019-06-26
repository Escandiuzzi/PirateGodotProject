extends Node2D

signal send_player_reward(player_reward);

export(bool) var is_bossIsland;

export(String) var islandType;
export(String) var regionName;
export(String) var scenePath;

export(float) var difficulty;

export(int) var enemies;
export(int) var islandSize;
export(int) var indexType;
export(int) var commonSize;
export(int) var uncommonSize;
export(int) var rareSize;
export(int) var maxRewards;


var selectedPirates = -1;
var pirates = [];
var pirateId = [];
var player;

var rewards = [];

onready var popupMenu = $PopupMenu;
onready var button = $Button;
onready var button2 = $Button2;
onready var rewardMenu = $RewardMenu;
onready var rewardText = $RewardMenu/RichTextLabel;

onready var item = preload("res://Item.tscn");

onready var island_menu = get_parent();
onready var text = get_parent().get_node("RichTextLabel");
onready var player_data = get_tree().get_root().get_node("/root/PlayerData");
onready var battle_manager = get_tree().get_root().get_node("/root/BattleManager");
onready var global = get_tree().get_root().get_node("/root/Global");


onready var canvasSlots = [
get_node("PopupMenu/CheckBox"),
get_node("PopupMenu/CheckBox2"),
get_node("PopupMenu/CheckBox3"),
get_node("PopupMenu/CheckBox4"),
get_node("PopupMenu/CheckBox5"),
get_node("PopupMenu/CheckBox6"),
get_node("PopupMenu/CheckBox7"),
get_node("PopupMenu/CheckBox8"),
get_node("PopupMenu/CheckBox9"),
get_node("PopupMenu/CheckBox10")
]

func _ready():
	player = get_tree().get_root().get_node("World/Player");
	for i in range(islandSize):
		pirates.append(null);
		pirateId.append(null);

	text.text += "              " + islandType + "    \n";
	text.text += "\n Difficulty: " + str(difficulty) + "\n";
	text.text += "\n Number of enemies: " + str(enemies) + "\n";
	pass 

func _clearIsland():
	pirates.clear();
	pass;

func _on_CheckBox_toggled(button_pressed, extra_arg_0):
	if button_pressed == true:
		if selectedPirates < islandSize - 1:
			selectedPirates += 1;
			pirateId[selectedPirates] = extra_arg_0;
		else:
			canvasSlots[extra_arg_0].pressed = false
	
	else:
		pirateId[selectedPirates] = null;
		selectedPirates -= 1;
	pass;

func _insertPirates():
	pirateId.sort();
	for i in range(islandSize):
		if pirateId[i] == null:
			break;
		pirates[i] = player._get_pirate(pirateId[i]);
		pirates[i]._set_busy(true);
	pass

func _on_StartButton_pressed():
	popupMenu.hide();
	global._set_player_coordinates(player.position);
	if selectedPirates > -1:
			get_tree().change_scene("res://BattleScene.tscn");
			player_data._selected_pirates(pirateId);
			battle_manager._island_data(difficulty, enemies, regionName, indexType, commonSize, uncommonSize, rareSize, maxRewards, islandType, scenePath, is_bossIsland);
			button.hide();
	pass;

func _on_CollectButton_pressed():
	rewardMenu.hide();
	button2.hide();
	pass 

func _getRewards():	
	randomize();
	var rewardN = randi() % maxRewards + 1;
	var rewards = {};
	for i in range(rewardN):
		#/////////////////////////////////////////
		var rarity = randi() % 85;
		var _item = item.instance();
		if rarity > 85:
			var randReward = randi() % rareSize;
			_item._read_json_data(randReward, regionName, "Rare");
			_item._print_data();
		
		else:
			var randReward = randi() % commonSize;
			_item._read_json_data(randReward, regionName, "Common");
			_item._print_data();
		
		if rewards.has(_item._get_name()):
			var item_count = rewards[_item._get_name()];
			item_count += 1;
			rewards[_item._get_name()] = item_count;
		else:
			rewards[_item._get_name()] = 1;
		
		#rewardText.text += _item._get_name();
		#rewardText.text += "\n";
		emit_signal("send_player_reward", _item);
		#/////////////////////////////////////////
		
	var keys = rewards.keys();
	for i in range(rewards.size()):
		rewardText.text += str(rewards[keys[i]]);
		rewardText.text += "x ";
		rewardText.text += keys[i];
		rewardText.text += "\n";

	for i in range(islandSize):
		if pirateId[i] == null:
			break;
		pirates[i]._set_busy(false);
	pirates.clear();
	
	pass;
