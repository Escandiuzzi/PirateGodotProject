extends PopupMenu

signal on_popupmenu_closed;

onready var data = get_tree().get_root().get_node("/root/PlayerData");

onready var pirate_menu = get_node("Island/PopupMenu");
onready var reward_menu = get_node("Island/RewardMenu");

export(Array) var island_states;
export(String) var path;

onready var sprite = get_parent().get_node("Sprite");
onready var button = get_parent().get_parent().get_node("Button");
onready var player = get_tree().get_root().get_node("World/Player");
onready var camera = get_tree().get_root().get_node("World/MainCamera");

func _process(delta):
	if button != null:
		if visible == false and button.visible == false:
			button.visible = true;
			camera.return_to_player();
	pass;


func _player_moved_hide():
	pirate_menu.hide();
	reward_menu.hide();
	self.hide();
	pass;


func _on_Close_pressed():
	self.hide();
	camera.return_to_player();
	pass 


func _on_timer_change(time):
	if time >= 0 and time < 1:
		sprite.texture = island_states[0];
	elif time > 0 and time < 100:
		sprite.texture = island_states[1];
	else:
		sprite.texture = island_states[2];
	pass;

func _on_Save_pressed():
	data._saveData();
	pass


func _on_CraftingButton_pressed():
	get_tree().change_scene("res://BattleScene.tscn");
	pass

