extends Node2D


onready var battleManager = get_tree().get_root().get_node("BattleManager");

var action;

var current_character;

onready var layer_1 = get_node("Layer 1");
onready var layer_2 = get_node("Layer 2");
onready var layer_3 = get_node("Layer 3");

var enemy_buttons = [
	get_node("Layer 2/FirstEnemyButton"),
	get_node("Layer 2/SecondEnemyButton"),
	get_node("Layer 2/ThirdEnemyButton")
];

var special_buttons = [
	get_node("Layer 3/SpecialButton1"),
	get_node("Layer 3/SpecialButton2"),
	get_node("Layer 3/SpecialButton3"),
	get_node("Layer 3/SpecialButton4"),
];

func _on_UIButton_pressed(extra_arg_0):
	action = extra_arg_0;
	
	if action == "Attack":
		layer_1.visible = false;
		layer_2.visible = true;
	
	elif action == "Special":
		layer_1.visible = false;
		layer_3.visible = true;
	
	else:
		battleManager._player_button_action(action, null);
	pass;

func _on_EnemyButton_pressed(extra_arg_0):
	battleManager._player_button_action(action, extra_arg_0);
	layer_1.visible = true;
	layer_2.visible = false;
	pass;

func _enemy_defeated(id):
	enemy_buttons[id].visible = false;
	pass;

func _layers_visible(status):
	if status == true:
		layer_1.visible = true;
		layer_2.visible = false;
	else:
		layer_1.visible = false;
		layer_2.visible = false;
	pass;
