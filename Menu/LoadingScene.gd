extends Control
var scene_path;
onready var global = get_node("/root/Global");
func _ready():
	for button in $Botoes.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load, button.action]);

func _on_Button_pressed(scene_to_load, action):
	print(action);
	if(action == "Continue"):
		global.setLoadGame();
	else:
		global.setNewGame();
	
	scene_path = scene_to_load;
	global.stopMenuMusic();
	get_tree().change_scene(scene_path);

func _on_Voltar_pressed():
	get_tree().change_scene('res://MainMenu.tscn')
