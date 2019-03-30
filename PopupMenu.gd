extends PopupMenu

onready var canvasSlots = [
$CheckBox,
$CheckBox2,
$CheckBox3,
$CheckBox4,
$CheckBox5,
$CheckBox6,
$CheckBox7,
$CheckBox8,
$CheckBox9,
$CheckBox10
]

export(String) var path;

var player;
var parent;


func _ready():
	player = get_tree().get_root().get_node("World/Player");
	parent = get_tree().get_root().get_node(path);
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CloseButton2_pressed():
	self.hide();
	for i in range(10):
		canvasSlots[i].visible = true;
	pass # Replace with function body.

func _on_Button_pressed():
	self.show();
	rect_position = parent.position;
	_check_player_crew();
	pass # Replace with function body.

func _check_player_crew():
	var crew = player._get_crew();
	for i in range(10):
		if crew[i] == null:
			canvasSlots[i].visible = false;

	pass;