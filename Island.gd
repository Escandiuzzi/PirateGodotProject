extends Node2D

export(int) var miningTime;
export(int) var islandSize;
export(int) var indexType;

var piratesCount;
var selectedPirates = 0;

var pirates = [];
var pirateId = [];
var started = false;

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
	for i in range(islandSize):
		pirates.append(null);
		pirateId.append(null);
	pass 
	
func _insertPirate(pirate):
	if piratesCount < islandSize:
		pirates[piratesCount] = pirate;
		piratesCount += 1;
	pass;

func _clearIsland():
	pirates.clear();
	pass;

func _startMining():
	if pirates.count() > 0:
		var miningPoints = 0;
		for i in range(piratesCount):
			miningPoints += pirates[i]._get_special(indexType);
		if miningPoints > miningTime:
			miningPoints = 1
		else:
			miningPoints = miningTime - miningPoints;
		timer.start();
		timer.wait_time = miningPoints;
		started = true;
	pass;

func _process(delta):
	if started:
		if timer.is_stopped():
			print("Pirates ended mining");
	pass

func _on_CheckBox_toggled(button_pressed, extra_arg_0):
	if button_pressed == true:
		if selectedPirates < islandSize:
			selectedPirates += 1;
			pirateId.push_back(extra_arg_0);
		else:
			canvasSlots[extra_arg_0].pressed = false
	
	else:
		selectedPirates -= 1;
		pirateId.remove(extra_arg_0);
	pass;


func _on_StartButton_pressed(): 
	pass # Replace with function body.

