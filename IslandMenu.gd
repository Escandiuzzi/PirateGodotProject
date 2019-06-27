extends PopupMenu

signal on_popupmenu_closed;

onready var data = get_tree().get_root().get_node("/root/PlayerData");

onready var pirate_menu = get_node("Island/PopupMenu");
onready var reward_menu = get_node("Island/RewardMenu");

export(Array) var island_states;

onready var sprite = get_parent().get_node("Sprite");
onready var button = get_parent().get_parent().get_node("Button");
onready var player = get_tree().get_root().get_node("World/Player");
onready var camera = get_tree().get_root().get_node("World/MainCamera");
onready var global = get_node("/root/Global");

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
	global.playButtonSound();
	self.hide();
	camera.return_to_player();
	pass;
	
	
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
	global._set_player_coordinates(player.position);
	get_tree().change_scene("res://CraftingStation.tscn");
	pass

