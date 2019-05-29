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

onready var pirateStat = $PirateStat;

func _ready():
	player = get_tree().get_root().get_node("World/Player");
	parent = get_tree().get_root().get_node(path);
	rect_position.x = parent.position.x - (rect_size.x/2);
	rect_position.y = parent.position.y - (rect_size.y/2);
	pass 
	

func _on_CloseButton2_pressed():
	self.hide();
	for i in range(10):
		canvasSlots[i].visible = true;
	pass

func _on_Button_pressed():
	self.show();
	_check_player_crew();
	pass

func _check_player_crew():
	var crew = player._get_crew();
	for i in range(crew.size()):
		if crew[i] == null || crew[i]._get_busy() == true:
			canvasSlots[i].visible = false;
		else:
			canvasSlots[i].visible = true;
	pass;

func _on_Area2D_mouse_entered(extra_arg_0):	
	var pirate = player._get_pirate(extra_arg_0);
	pirateStat.text = "";
	pirateStat.text += "Mining: " + str(pirate._get_stat("mining")) + "\n";
	pirateStat.text += "Battle: " + str(pirate._get_stat("atk")) + "\n";	
	pirateStat.text += "Cooking: " + str(pirate._get_stat("cooking")) +"\n";
	pirateStat.rect_position = canvasSlots[extra_arg_0].rect_position;
	pirateStat.show();	
	pass;
	
func _on_Area2D_mouse_exited():
	pirateStat.hide();	
	pass;
