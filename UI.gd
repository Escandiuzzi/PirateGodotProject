extends Control

onready var viewport = get_viewport();
onready var background = get_tree().get_root().get_node("BattleScene/Manager/UI/Background");
onready var hud = get_tree().get_root().get_node("BattleScene/Manager/UI/HUD");
var minimum_size = Vector2(1440, 900);
var image;

func _ready():
	viewport.connect("size_changed", self, "window_resize");
	window_resize();
	pass;

func window_resize():
	var current_size = OS.get_window_size();
	
	background.rect_size.x = current_size.x;
	background.rect_size.y = current_size.y;
	hud.rect_size.x = current_size.x;
	hud.rect_size.y = current_size.y;
	pass;