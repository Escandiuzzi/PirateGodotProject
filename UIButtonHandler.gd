extends Node2D


onready var battleScene = get_parent().get_parent().get_parent();

var ia_slots = 2;

var action;
var special_id;
var current_character;

onready var background = get_node("Layer 3/Background");
onready var text = get_node("Layer 3/Text");

onready var panel = get_parent().get_parent().get_parent().get_node("Panel");
onready var recruit_panel = get_parent().get_parent().get_parent().get_node("RecruitPirate");
onready var layer_1 = get_node("Layer 1");
onready var layer_2 = get_node("Layer 2");
onready var layer_3 = get_node("Layer 3");
onready var inventory_screen = get_parent().get_parent().get_parent().get_node("InventoryScreen");


onready var enemy_buttons = [
	get_node("Layer 2/FirstEnemyButton"),
	get_node("Layer 2/SecondEnemyButton"),
	get_node("Layer 2/ThirdEnemyButton")
];

onready var special_buttons = [
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
		_special_buttons();
		_check_player_energy();
	elif action == "Inventory":
		inventory_screen.visible = true;
	pass;

func _on_EnemyButton_pressed(extra_arg_0):
	battleScene._player_button_action(action, extra_arg_0, special_id, null);
	layer_1.visible = true;
	layer_2.visible = false;
	special_id = -1;
	
	current_character = battleScene._get_current_character();
	pass;

func _ia_defeated():
	enemy_buttons[ia_slots].visible = false;
	ia_slots -= 1;
	pass;

func _layers_visible(status):
	
	if status == true:
		layer_1.visible = true;
		layer_2.visible = false;
		layer_3.visible = false;
	else:
		layer_1.visible = false;
		layer_2.visible = false;
		layer_3.visible = false;
	pass;
	

func _special_buttons():
	current_character = battleScene._get_current_character();
	
	for i in range(special_buttons.size()):
		special_buttons[i].text = current_character._get_special_attack(i)._get_stat("name");
	pass;

func _on_SpecialButton_pressed(extra_arg_0):
	special_id = extra_arg_0;
	
	if (special_id == 1 and int(current_character._get_special_attack(extra_arg_0)._get_stat("damage")) == 0):
		
		battleScene._player_button_action(action, 0, special_id, null);
		special_id = -1;
		layer_1.visible = true;
		layer_2.visible = false;
		layer_3.visible = false;
		current_character = battleScene._get_current_character();
	
	else:
		layer_2.visible = true;
		layer_3.visible = false;
	pass;


func _on_SpecialButton_mouse_entered(extra_arg_0):
	background.visible = true;
	text.visible = true;
	
	text.text = "Damage: " + str(current_character._get_special_attack(extra_arg_0)._get_stat("damage")) + "\n";
	text.text += "Heal: " + str(current_character._get_special_attack(extra_arg_0)._get_stat("heal")) + "\n";
	text.text += "Range: " + str(current_character._get_special_attack(extra_arg_0)._get_stat("range")) + "\n";
	text.text += "Energy: " + str(current_character._get_special_attack(extra_arg_0)._get_stat("energy")) + "\n";
	pass;

func _on_SpecialButton_mouse_exited():
	background.visible = false;
	text.visible = false;
	pass;
	
func _on_ReturnButton_pressed():
	layer_1.visible = true;
	layer_2.visible = false;
	layer_3.visible = false;
	pass;

func _check_player_energy():
	
	var player_energy = current_character._get_energy();
	
	for i in range(4):
		if int(current_character._get_special_attack(i)._get_stat("energy")) > player_energy:
			special_buttons[i].disabled = true;
		else:
			special_buttons[i].disabled = false;
	pass;

func _on_Button_pressed():
	panel.visible = false;
	recruit_panel.visible = true;
	pass;

func _on_CloseInventoryButton_pressed():
	inventory_screen.visible = false;
	pass;

func _on_UIInputHandler_on_item_selected(item_stats):
	inventory_screen.visible = false;
	battleScene._player_button_action(action, -1, -1, item_stats);
	pass;
