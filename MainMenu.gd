extends Control

var scene_path;

onready var global = get_node("/root/Global");

var action;
var screenSize = Vector2(0,0)
#onready var background = $Menu/TextureRect;
func _ready():
	for button in $Centro/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load, button.action]);
	var save_game = File.new();
	if not save_game.file_exists("res://savegame.json"):
		$Centro/Buttons/ContinueButton.set_visible(false);
	else:
		print("save exist");
		

func _on_Button_pressed(scene_to_load, action):
	print(action);
	if(action == "Continue"):
		global.setLoadGame();
	elif action == "Exit":
		get_tree().quit();
	else:
		global.setNewGame();
	
	scene_path = scene_to_load;
	
	$FadeIn.show();
	$FadeIn.fade_in();

func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path);
func _process(delta):
	screenSize.x = get_viewport().get_visible_rect().size.x # Get Width
	screenSize.y = get_viewport().get_visible_rect().size.y # Get Height
	#background.STRETCH_SCALE = 1;
	#background.rect_size(screenSize.x, screenSize.y);
	