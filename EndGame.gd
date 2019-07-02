extends Control

onready var global = get_node("/root/Global");

var page = 1;
func _ready():
	pass # Replace with function body.



func _on_Button_pressed():
	global.playButtonSound();
	$FadeIn.show();
	$FadeIn.fade_in();

func _on_FadeIn_fade_finished():
	$FadeIn.hide();
	page += 1;
	if(page == 2):
		$Pag1.visible = false;
		$Pag2.visible = true;
	if(page == 3):
		$Pag2.visible = false;
		$Pag3.visible = true;
	if(page == 4):
		$Pag3.visible = false;
		$Fim.visible = true;
		global.stopBack();
		global.playThunder();
		yield(get_tree().create_timer(5.5),"timeout");
		$Fim/Label.visible = true;
		yield(get_tree().create_timer(5.0),"timeout");
		$Fim/Button2.visible = true;


func _on_Button2_pressed():
	global.playButtonSound();
	global.stopThunder();
	get_tree().change_scene('res://MainMenu.tscn');
