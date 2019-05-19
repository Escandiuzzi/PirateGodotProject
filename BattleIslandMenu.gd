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