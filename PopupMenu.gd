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
export(String) var islandType;

var player;
var parent;

onready var pirateStat = $PirateStat;
onready var global = get_node("/root/Global");
func _ready():
	player = get_tree().get_root().get_node("World/Player");
	parent = get_parent().get_parent().get_parent().get_parent();
	rect_position.x = parent.position.x - (rect_size.x/2);
	rect_position.y = parent.position.y - (rect_size.y/2);
	pass 
	

func _on_CloseButton2_pressed():
	global.playButtonSound();
	self.hide();
	pass

func _on_Button_pressed():
	global.playButtonSound();
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
	if islandType == "Resource":
		pirateStat.text = "";
		pirateStat.text += "Mining: " + str(pirate._get_stat("mining")) + "\n";
		pirateStat.text += "Battle: " + str(pirate._get_stat("atk")) + "\n";	
		pirateStat.text += "Cooking: " + str(pirate._get_stat("cooking")) +"\n";
		pirateStat.rect_position = canvasSlots[extra_arg_0].rect_position;
	elif islandType == "Battle":
		pirateStat.text = "";
		pirateStat.text += "HP: " + str(pirate._get_hp()) +  " / " + str(pirate._get_max_hp()) + "\n";	
		pirateStat.text += "Attack: " + str(pirate._get_stat("atk")) +  " - " + str(pirate._get_stat("atk") + 2) + "\n";	
		pirateStat.text += "Energy: " + str(pirate._get_energy()) +  " / " + str(pirate._get_max_energy()) + "\n";
		if pirate._get_weapon() != null:
			pirateStat.text += "Weapon: " + pirate._get_weapon()._get_name() + "\n";
			pirateStat.text += "Weapon Durability: " + str(pirate._get_weapon()._get_stat("durability")) + "\n";
		if  pirate._get_shield() != null:
			pirateStat.text += "Shield: " + pirate._get_shield()._get_name() + "\n";
			pirateStat.text += "Shield Durability: " + str(pirate._get_shield()._get_stat("durability")) + "\n";
		pirateStat.text += "AtkBonus: " + str(pirate._get_stat("atkBonus")) + "\n";
		pirateStat.text += "DefBonus: " + str(pirate._get_stat("defBonus")) + "\n";	
	pirateStat.show();	
	pass;
	
func _on_Area2D_mouse_exited():
	pirateStat.hide();	
	pass;

