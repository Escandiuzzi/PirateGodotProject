extends PopupMenu;
onready var global = get_node("/root/Global");
func _on_Button_pressed():
	global.playButtonSound();
	self.visible = false;
	pass 
	
