extends PopupMenu

onready var pirate_menu = get_node("Island/PopupMenu");
onready var reward_menu = get_node("Island/RewardMenu");

export(Array) var island_states;

export(Texture) var defeated_texture;

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

func _set_defeated_state():
	sprite.texture = defeated_texture;
	pass;
