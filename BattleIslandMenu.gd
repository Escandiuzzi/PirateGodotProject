extends PopupMenu

onready var pirate_menu = get_node("Island/PopupMenu");
onready var reward_menu = get_node("Island/RewardMenu");

export(Array) var island_states;

onready var sprite = get_parent().get_node("Sprite");
onready var button = get_parent().get_parent().get_node("Button");

func _process(delta):
	if button != null:
		if visible == false and button.visible == false:
			button.visible = true;
			
	pass;

func _player_moved_hide():
	pirate_menu.hide();
	reward_menu.hide();
	self.hide();
	pass;

func _on_Close_pressed():
	self.hide();
	pass 