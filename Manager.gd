extends Node2D

onready var playerData = get_tree().get_root().get_node("/root/PlayerData");
onready var battleManager = get_tree().get_root().get_node("/root/BattleManager");

var p_characters;
var ia_characters;

onready var p_healthbars = [
	get_node("UI/HealthBars/character1_HealthBar"),
	get_node("UI/HealthBars/character2_HealthBar"),
	get_node("UI/HealthBars/character3_HealthBar")	
];

onready var ia_healthbars = [
	get_node("UI/HealthBars/enemy1_HealthBar"),
	get_node("UI/HealthBars/enemy2_HealthBar"),
	get_node("UI/HealthBars/enemy3_HealthBar")	
];

func _ready():
	playerData._test();
	pass;

func _process(delta):
	if(p_characters != null and ia_characters != null):
		_update_healthbar();
	else:
		_set_characters();
	pass;

func _set_characters():
	p_characters = battleManager._get_p_characters();	
	ia_characters = battleManager._get_ia_characters();
	_update_healthbar();
	pass;

func _update_healthbar():
	
	for i in range(p_characters.size()):
		if p_characters[i] == null or p_characters[i]._get_hp() <= 0:
			p_healthbars[i].visible = false;
		else:
			
			var hp = p_characters[i]._get_hp();
			var max_hp = p_characters[i]._get_max_hp();
			var percentage = (100 * hp) / max_hp;	
			p_healthbars[i].set_value(percentage);
	
	for i in range(ia_characters.size()):
		if ia_characters[i] == null or ia_characters[i]._get_hp() <= 0:
			ia_healthbars[i].visible = false;
		else:
			var hp = ia_characters[i]._get_hp();
			var max_hp = ia_characters[i]._get_max_hp();
			var percentage = (100 * hp) / max_hp;	
			ia_healthbars[i].set_value(percentage);
	pass;



