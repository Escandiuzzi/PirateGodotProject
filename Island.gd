extends Node2D

signal on_timer_change(time_left);
signal send_player_reward(player_reward);

export(bool) var renewable;

export(String) var islandType;
export(String) var regionName;

export(int) var miningTime;
export(int) var islandSize;
export(int) var commonSize;
export(int) var uncommonSize;
export(int) var rareSize;
export(int) var maxRewards;
export(int) var cooldown_time;
export(int) var bonus;
export(int) var recruit_seed;

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
onready var recruit = $RecruitPirate;

onready var item = preload("res://Item.tscn");
onready var data = get_tree().get_root().get_node("/root/PlayerData");
onready var island_menu = get_parent();
onready var global = get_node("/root/Global");
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
	
	recruit.rect_position.x = popupMenu.rect_position.x - 50;
	recruit.rect_position.y = popupMenu.rect_position.y;
	
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
	timer.start(miningPoints); 
	started = true;
	
	pass;

func _process(delta):
	if started:
		#change 60 for miningTime
		var _percentage = 60 - timer.get_time_left();
		_percentage = (_percentage * 100) / 60;
		emit_signal("on_timer_change", _percentage);
		island_menu._on_timer_change(_percentage);
		if timer.is_stopped():
			print("Pirates ended mining");
			timer.stop();
			started = false;
			button2.show();
			_getRewards()
	
	if cooldown:
		var time_left = (100 * cooldown_timer.get_time_left()) / cooldown_time;
		emit_signal("on_timer_change", time_left);
		island_menu._on_timer_change(time_left);
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
		if selectedPirates < islandSize - 1:
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
	global.playButtonSound();
	popupMenu.hide();
	if selectedPirates > -1:
			_insertPirates();
			button.hide();
	pass;

func _on_CollectButton_pressed():
	global.playButtonSound();
	rewardMenu.hide();
	button2.hide();
	_rescue_crew();
	if renewable:
		_renewable_state();
		cooldown = true;
	
	randomize();
	var thold = randi() % 100;
		
	if thold >= recruit_seed:
		recruit.visible = true;
	pass 

func _getRewards():	
	randomize();
	var rewardN = randi() % maxRewards + 1;
	var rewards = {};
	for i in range(rewardN):
		#/////////////////////////////////////////
		var rarity = randi() % 100 + 1;
		var _item = item.instance();

		if rarity >= 90:
			var randReward = randi() % rareSize;
			_item._read_json_data(randReward, regionName, "Rare", islandType);
			_item._print_data();
		elif rarity >= 60 and rarity < 90:
			var randReward = randi() % uncommonSize;
			_item._read_json_data(randReward, regionName, "Uncommon", islandType);
			_item._print_data();
		else:
			var randReward = randi() % commonSize;
			_item._read_json_data(randReward, regionName, "Common", islandType);
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
	
	pass;

func _rescue_crew():
	for i in range(islandSize):
		if pirateId[i] == null:
			break;
		pirates[i]._set_busy(false);
		pirates[i]._set_post_mining_bonus(bonus);
	pirates.clear();
	pass;

func _renewable_state():
	cooldown_timer.start(cooldown_time);
	started = false;
	selectedPirates = 0;
	for i in range(islandSize):
		pirates.append(null);
		pirateId.append(null);
	selectedPirates = -1;
	pass;


func _on_RecruitButton_pressed():
	data._recruitPirate(1);
	recruit.visible = false;
	data._saveData();
	pass;
