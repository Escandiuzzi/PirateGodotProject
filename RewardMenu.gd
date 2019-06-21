extends PopupMenu

export(String) var path;

var parent;

func _ready():
	parent = get_parent().get_parent().get_parent().get_parent();
	rect_position.x = parent.position.x - (rect_size.x/2);
	rect_position.y = parent.position.y - (rect_size.y/2);
	pass 

func _on_Button2_pressed():
	self.show();
	pass 
