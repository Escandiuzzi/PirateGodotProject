extends Node2D

var id;
var tag;
var hp;
var defBonus;
var busy;

var stats = {
	"atk": 0,
	"def": 0,
	"speed": 0,
	"mining": 0,
	"cooking": 0
};
var keys = [
	"atk",
	"def",
	"speed",
	"mining",
	"cooking"
]

onready var pirateStat = get_node("pirateStat");
onready var sprite = $Sprite;

var miningtexture = load("res://Sprite/entities/player/mining.png");
var idle = load("res://Sprite/entities/player/pirate.png");

func _ready():
	pass

func _initializePirate():
	print("New Pirate created with: ")
	for i in range(5):
		randomize();
		var r = randi() & 100; 
		if r  > 87: #rare pirate
			var s = randi() % 9 + 1;
			print(s);
			stats[keys[i]] = s;	
		else: #common pirate
			var s = randi() % 3 + 1;
			print(s);
			stats[keys[i]] = s;	
	pass
	
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
		"attack" : stats["atk"],
		"defense" : stats["def"],
		"speed" : stats["speed"],
		"mining" : stats["mining"],
		"cooking" : stats["cooking"]
		}
	return save_dict;

func _setData(_id, _tag, _hp, _atk, _def, _speed, _mining, _cooking):	
	id = _id;
	tag = _tag;
	hp = _hp;
	stats["atk"] = _atk;
	stats["def"] = _def;
	stats["speed"] = _speed;
	stats["mining"] = _mining;
	stats["cooking"] = _cooking;
	
	print("updating data")
	print(id);
	print(tag);
	print(hp);
	print(stats["atk"]);
	print(stats["def"]);
	print(stats["speed"]);
	print(stats["mining"]);
	print(stats["cooking"]);
	
	pass; 

func _get_stat(index):
	return stats[index];
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
	pass;

func _get_hp():
	return hp;
	pass;

func _set_def_bonus(bonus):
	defBonus = bonus;
	pass;

func _get_def_bonus():
	return defBonus;
	pass;

func _on_Area2D_mouse_entered():
	pirateStat.text = "";
	pirateStat.text += "Mining: " + str(_get_stat("mining")) + "\n";
	pirateStat.text += "Battle: " + str(_get_stat("atk")) + "\n";	
	pirateStat.text += "Cooking: " + str(_get_stat("cooking")) +"\n";
	pirateStat.show();
	pass; 

func _on_Area2D_mouse_exited():
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

func _change_sprite(spr):
	sprite.texture = spr;
	pass;