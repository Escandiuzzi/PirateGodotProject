extends PopupMenu

onready var pirate_menu = get_node("Island/PopupMenu");
onready var reward_menu = get_node("Island/RewardMenu");

export(Array) var island_states;

onready var sprite = get_parent().get_node("Sprite");

func _player_moved_hide():
	pirate_menu.hide();
	reward_menu.hide();
	self.hide();
	pass;


func _on_Close_pressed():
	self.hide();
	pass 


func _on_timer_change(time):
	if time >= 0 and time < 1:
		sprite.texture = island_states[0];
	elif time > 0 and time < 100:
		sprite.texture = island_states[1];
	else:
		sprite.texture = island_states[2];
	pass;