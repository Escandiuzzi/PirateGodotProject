extends Node2D

signal on_timer_change(time_left);
signal send_player_reward(player_reward);

export(int) var miningTime;
export(int) var islandSize;
export(int) var indexType;

var selectedPirates = 0;
var pirates = [];
var pirateId = [];
var started = false;
var player;

var rewards = [];

onready var popupMenu = $PopupMenu;
onready var button2 = $Button2;
onready var rewardMenu = $RewardMenu;
onready var rewardText = $RewardMenu/TextEdit;
onready var timer = $Timer;
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
	for i in range(selectedPirates):
		miningPoints += pirates[i]._get_special(indexType);
	if miningPoints > miningTime:
		miningPoints = 1;
	else:
		miningPoints = miningTime - miningPoints;
	
	miningPoints = miningPoints * 60;
	
	print("Started mining");
	print("expected to end in ");
	print(miningPoints);

	miningTime = miningPoints;
	timer.start(miningPoints); 
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
			_getRewards();
	pass

func _on_CheckBox_toggled(button_pressed, extra_arg_0):
	if button_pressed == true:
		if selectedPirates < islandSize:
			selectedPirates += 1;
			pirateId.push_front(extra_arg_0);
		else:
			canvasSlots[extra_arg_0].pressed = false
	
	else:
		selectedPirates -= 1;
		pirateId.remove(extra_arg_0);
	pass;

func _insertPirates():
	pirateId.sort();
	for i in range(selectedPirates):
		if pirateId[i] == null:
			break;
		pirates[i] = player._get_pirate(pirateId[i]);
	_startMining();
	pass

func _on_StartButton_pressed():
	popupMenu.hide();
	if selectedPirates > 0:
			_insertPirates();
	pass;

func _on_CollectButton_pressed():
	rewardMenu.hide();
	
	pass # Replace with function body.

func _getRewards():	
	var rewardN = randi() % 9 + 1;
	for i in range(rewardN):
		rewards.append(null);
	
	var itens_file = File.new();

	if not itens_file.file_exists("res://itens.save"):
		print("file does not exists");
		return;
		
	itens_file.open("res://itens.save", File.READ)
	while not itens_file.eof_reached():
		var current_line = parse_json(itens_file.get_line());
		for i in range(rewardN):
			var randReward = randi() % 9 + 1;
			rewards[i] = current_line[str(randReward)];
			print(rewards[i]);
		current_line = parse_json(itens_file.get_line());
	itens_file.close();
	
	for i in range(rewardN):
		rewardText.text += rewards[i];
		rewardText.text += "\n";
	emit_signal("send_player_reward", rewards);
	pass;