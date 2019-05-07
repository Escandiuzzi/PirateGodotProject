extends Node2D

signal on_timer_change(time_left);
signal send_player_reward(player_reward);

export(bool) var renewable;

export(String) var islandType;
export(String) var regionName;

export(int) var miningTime;
export(int) var islandSize;
export(int) var indexType;
export(int) var commonSize;
export(int) var uncommonSize;
export(int) var rareSize;
export(int) var maxRewards;
export(int) var cooldown_time;


var selectedPirates = -1;
var pirates = [];
var pirateId = [];
var started = false;
var player;
var cooldown = false;

var rewards = [];

onready var popupMenu = $PopupMenu;
onready var button = $Button;
onready var button2 = $Button2;
onready var rewardMenu = $RewardMenu;
onready var rewardText = $RewardMenu/RichTextLabel;
onready var timer = $Timer;
onready var cooldown_timer = $CooldownTimer;

onready var item = preload("res://Item.tscn");

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
	pass 

func _clearIsland():
	pirates.clear();
	pass;

func _startMining():
	var miningPoints = 0;
	miningPoints = 0;
	for i in range(islandSize):
		if pirates[i] != null:
			miningPoints += pirates[i]._get_stat("mining");
	if miningPoints > miningTime:
		miningPoints = 1;
	else:
		miningPoints = miningTime - miningPoints;
	
	miningPoints = miningPoints * 60;
	
	print("Started mining");
	print("expected to end in ");
	print(miningPoints);

	miningTime = miningPoints;
	timer.start(miningTime); 
	started = true;
	pass;

func _process(delta):
	if started:
		var _percentage = miningTime - timer.get_time_left();
		_percentage = (_percentage * 100) / miningTime;
		emit_signal("on_timer_change", _percentage);
		if timer.is_stopped():
			print("Pirates ended mining");
			timer.stop();
			started = false;
			button2.show();
			_getRewards()
	
	if cooldown:
		var time_left = (100 * cooldown_timer.get_time_left()) / cooldown_time;
		emit_signal("on_timer_change", time_left);
		if cooldown_timer.is_stopped():
			cooldown_timer.stop();
			button.show();
			cooldown = false;
			emit_signal("on_timer_change", 0);
			for i in canvasSlots:
				i.pressed = false;
	pass

func _on_CheckBox_toggled(button_pressed, extra_arg_0):
	if button_pressed == true:
		if selectedPirates < islandSize:
			selectedPirates += 1;
			pirateId[selectedPirates] = extra_arg_0;
		else:
			canvasSlots[extra_arg_0].pressed = false
	
	else:
		selectedPirates -= 1;
		pirateId.remove(extra_arg_0);
	pass;

func _insertPirates():
	pirateId.sort();
	for i in range(islandSize):
		if pirateId[i] == null:
			break;
		pirates[i] = player._get_pirate(pirateId[i]);
		pirates[i]._set_busy(true);
	_startMining();
	pass

func _on_StartButton_pressed():
	popupMenu.hide();
	if selectedPirates > -1:
			_insertPirates();
			button.hide();
	pass;

func _on_CollectButton_pressed():
	rewardMenu.hide();
	button2.hide();
	if renewable:
		_renewable_state();
		cooldown = true;
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

func _renewable_state():
	cooldown_timer.start(cooldown_time);
	started = false;
	selectedPirates = 0;
	for i in range(islandSize):
		pirates.append(null);
		pirateId.append(null);
	miningTime = 0;
	selectedPirates = -1;
	pass;