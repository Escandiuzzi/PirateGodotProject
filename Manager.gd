extends Node2D

onready var playerData = get_tree().get_root().get_node("/root/PlayerData");
onready var battleScene = get_tree().get_root().get_node("BattleScene");
onready var ui_handler = get_node("UI/UIButtonHandler");

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

func _process(delta):
	if(p_characters != null and ia_characters != null):
		_update_healthbar();
	else:
		_set_characters();
	pass;

func _set_characters():
	p_characters = battleScene._get_p_characters();	
	ia_characters = battleScene._get_ia_characters();
	_update_healthbar();
	pass;

func _update_healthbar():
	
	for i in range(p_healthbars.size()):
		if p_characters.size() - 1  < i or p_characters[i]._get_hp() <= 0:
			p_healthbars[i].visible = false;
		else:
			var hp = p_characters[i]._get_hp();
			var max_hp = p_characters[i]._get_max_hp();
			var percentage = (100 * hp) / max_hp;	
			p_healthbars[i].set_value(percentage);
	
	for i in range(ia_healthbars.size()):
		if ia_characters.size() - 1 < i or ia_characters[i]._get_hp() <= 0:
			ia_healthbars[i].visible = false;
		else:
			var hp = ia_characters[i]._get_hp();
			var max_hp = ia_characters[i]._get_max_hp();
			var percentage = (100 * hp) / max_hp;	
			ia_healthbars[i].set_value(percentage);
	pass;

func _remove_healthbar(id, index):
	if id == 0:
		var hb = p_healthbars[index];
		p_healthbars.erase(hb);
		hb.queue_free();
	else:
		var hb = ia_healthbars[index];
		ia_healthbars.erase(hb);
		hb.queue_free();
	pass;

