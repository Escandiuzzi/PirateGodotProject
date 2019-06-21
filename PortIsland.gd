extends Node2D;

signal on_pirate_selected(pirate);

export(int) var islandSize;


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

onready var item = preload("res://Item.tscn");

onready var island_menu = get_parent();

var current_pirate;

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

func _on_CheckBox_toggled(button_pressed, extra_arg_0):
	if button_pressed == true:
		if selectedPirates < islandSize - 1:
			selectedPirates += 1;
			pirateId[selectedPirates] = extra_arg_0;
			current_pirate = extra_arg_0;
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
	pass;

func _on_StartButton_pressed():
	popupMenu.hide();
	emit_signal("on_pirate_selected", current_pirate);
	pass;
