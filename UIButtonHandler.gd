extends Node2D


onready var battleManager = get_tree().get_root().get_node("BattleManager");

var action;

onready var layer_1 = get_node("1 Layer");
onready var layer_2 = get_node("2 Layer");

var enemy_buttons = [
	get_node("2 Layer/FirstEnemyButton"),
	get_node("2 Layer/SecondEnemyButton"),
	get_node("2 Layer/ThirdEnemyButton")
]

func _on_UIButton_pressed(extra_arg_0):
	action = extra_arg_0;
	
	if action == "Attack":
		layer_1.visible = false;
		layer_2.visible = true;
	
	elif action == "Defend" or action == "Inventory":
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
