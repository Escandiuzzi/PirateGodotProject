extends TextEdit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("World/Player");
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	self.hide();
	pass # Replace with function body.


func _on_InventoryButton_pressed():
	self.show();
	text = "";
	var inventory = player._get_inventory();
	var keys = inventory._get_keys();
	
	for i in range(keys.size()):
		text += str(inventory._get_item_count(keys[i]));
		text += "x "
		text += keys[i];
		text += "\n";
	pass # Replace with function body.
