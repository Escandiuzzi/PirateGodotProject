extends RichTextLabel


var player;
var background;
export(NodePath) var bgd_path;

func _ready():
	player = get_tree().get_root().get_node("World/Player");
	background = get_parent().get_node("Background");
	pass # Replace with function body.


func _on_Button_pressed():
	self.hide();
	background.visible = false;
	pass # Replace with function body.


func _on_InventoryButton_pressed():
	self.show();
	background.visible = true;
	text = "";
	var inventory = player._get_inventory();
	var keys = inventory._get_keys();
	
	for i in range(keys.size()):
		text += str(inventory._get_item_count(keys[i]));
		text += "x "
		text += keys[i];
		text += "\n";
	pass # Replace with function body.