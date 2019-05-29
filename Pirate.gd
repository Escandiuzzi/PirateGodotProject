extends Node2D

var id;
var tag;
var hp;
var max_hp;
var energy;
var max_energy;
var busy;

var special_attacks = [];

var stats = {
	"atk": 0,
	"mining": 0,
	"cooking": 0,
	"special": []
};
var keys = [
	"atk",
	"mining",
	"cooking",
	"special"
]

onready var pirateStat = get_node("pirateStat");
onready var statBGD = get_node("textBGD");
onready var sprite = $Sprite;

var miningtexture = load("res://Sprite/entities/player/mining.png");
var idle = load("res://Sprite/entities/player/pirate.png");

onready var special_obj = preload("res://Special.tscn");


func _ready():
	pass

func _initializePirate():
	hp = 15; #for test purposes
	max_hp = hp;
	
	randomize();
	var rand = randi() & 100;
	var _hp;
	if rand >= 95: #ultra rare pirate
			_hp = randi() % 18 + 8;
	elif rand  > 87 and rand < 95: #rare pirate
			_hp = randi() % 11 + 6;
	else: #common pirate
			_hp = randi() % 9 + 8;
	
	hp = _hp;
	max_hp = hp;
	
	randomize();
	var rand2 = randi() & 100;
	var _energy;
	
	if rand2 >= 97: #ultra rare pirate
			_energy = randi() % 18 + 8;
	elif rand2  > 90 and rand2 < 97: #rare pirate
			_energy = randi() % 11 + 6;
	else: #common pirate
			_energy = randi() % 9 + 6;
	
	energy = _energy;
	max_energy = energy;
	
	for i in range(3):
		randomize();
		var r = randi() & 100;
		
		if i == 0: #attack stat
			if r >= 95: #ultra rare pirate
					var s = randi() % 7 + 3;
					stats[keys[i]] = s;	
			elif r  > 87 and r < 95: #rare pirate
					var s = randi() % 5 + 2;
					stats[keys[i]] = s;	
			else: #common pirate
					var s = randi() % 4 + 1;
					stats[keys[i]] = s;	

		else:
			if r >= 95: #ultra rare pirate
				var s = randi() % 6 + 5;
				stats[keys[i]] = s;	
			elif r  > 87 and r < 95: #rare pirate
				var s = randi() % 5 + 3;
				stats[keys[i]] = s;	
			else: #common pirate
				var s = randi() % 3 + 1;
				stats[keys[i]] = s;	
	
	var special_ids = [];
	
	for i in range(4):
		randomize();
		var index = int(rand_range(0,4));
		special_ids.append(null);
		special_ids[i] = index;
	
	pass
	
	stats["special"] = special_ids;
	
func _setId(_id):
	id = _id;
	pass;

func _get_id():
	return id;
	pass;

func _savePirate():
	var save_dict = {
		"id" : id,
		"tag" : tag,
		"hp" : hp,
		"maxHp" : max_hp,
		"energy" : energy,
		"maxEnergy": max_energy,
		"attack" : stats["atk"],
		"mining" : stats["mining"],
		"cooking" : stats["cooking"],
		"special" : stats["special"]
		}
	
	return save_dict;

func _setData(_id, _tag, _hp, _max, _ener, _max_e, _atk, _mining, _cooking, _special):	
	id = _id;
	tag = _tag;
	hp = _hp;
	max_hp = _max;
	energy = _ener;
	max_energy = _max_e;
	stats["atk"] = _atk;
	stats["mining"] = _mining;
	stats["cooking"] = _cooking;
	stats["special"] = _special;
	pass; 

func _get_stat(index):
	return stats[index];
	pass;

func _set_stat(index, bonus):
	stats[index] = int(stats[index] + int(bonus));
	pass;

func _set_busy(status):
	busy = status;
	if busy == true:
		sprite.texture = miningtexture;
	else: 
		sprite.texture = idle;
	pass;

func _get_busy():
	return busy;

func _set_hp(_hp):
	hp = _hp;
	
	if hp > max_hp:
		hp = max_hp;
	pass;

func _get_hp():
	return hp;
	pass;

func _set_max_hp(_hp):
	max_hp = _hp;
	pass;

func _get_max_hp():
	return max_hp;
	pass;

func _set_energy(_energy):
	energy = _energy;
	
	if energy > max_energy:
		energy = max_energy;
	
	elif energy <= 0:
		energy = 0;	
	pass;

func _get_energy():
	return energy;
	pass;

func _set_max_energy(_max_e):
	max_energy = _max_e;
	pass;

func _get_max_energy():
	return max_energy;
	pass;

func _on_Area2D_mouse_entered():
	
	if get_tree().get_current_scene().get_name() == "BattleScene":
		pirateStat.text = "";
		pirateStat.text += "HP: " + str(_get_hp()) +  " / " + str(max_hp) + "\n";	
		pirateStat.text += "Attack: " + str(_get_stat("atk")) +  " - " + str(_get_stat("atk") + 2) + "\n";	
		pirateStat.text += "Energy: " + str(energy) +  " / " + str(max_energy) + "\n";	
	
	else:
		pirateStat.text = "";
		pirateStat.text += "Mining: " + str(_get_stat("mining")) + "\n";
		pirateStat.text += "Battle: " + str(_get_stat("atk")) + "\n";	
		pirateStat.text += "Cooking: " + str(_get_stat("cooking")) +"\n";
		pirateStat.set_scale(Vector2(1.8, 1.8));
		
	
	statBGD.show();
	pirateStat.show();
	
	pass; 

func _on_Area2D_mouse_exited():
	statBGD.hide();
	pirateStat.hide();
	pass;

func _set_tag(id):
	if id == 0:
		tag = "Player";
	else:
		tag = "IA";
	pass;

func _get_tag():
	return tag;
	pass;

func _set_post_mining_bonus(bonus):
	print("stat upgraded ")
	print(stats["mining"]); print("--->"); print(stats["mining"] + bonus)
	stats["mining"] += bonus;
	
	pass;
	
func _set_post_battle_bonus(bonus):
	
	randomize();
	var b_bonus = randi() % bonus;
	bonus -= b_bonus;
	stats["atk"] +=  b_bonus;
	
	b_bonus = randi() % bonus;
	bonus -= b_bonus;
	_set_max_hp(_get_max_hp() + b_bonus);
	_set_hp(_get_hp() + b_bonus);
	
	_set_max_energy(_get_max_energy() + bonus);
	_set_energy(_get_energy() + b_bonus);
	
	pass;

func _change_sprite(spr):
	sprite.texture = spr;
	pass;
	
func _instantiate_special():
	
	for i in range(4):
		special_attacks.append(null);
		var s = special_obj.instance();
		s._get_data(str(i), stats["special"][i]);
		special_attacks[i] = s;
	pass;

func _clear_specials():
	for i in range(special_attacks.size()):
		special_attacks[i].queue_free();
	
	special_attacks.clear();
	pass;

func _get_special_attack(index):
	return special_attacks[index];
	pass;