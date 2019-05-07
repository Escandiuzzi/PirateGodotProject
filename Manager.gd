extends Node2D

onready var battleManager = get_tree().get_root().get_node("BattleManager");

export(Array) var player_pos;
export(Array) var ia_pos;

var characters;

var player_texture = load("res://Sprite/characters/idle_warrior.png");
var enemy_texture = load("res://Sprite/characters/idle_mimic.png");


func _ready():
	#_draw_characters();
	pass;

func _draw_characters():
	characters = battleManager._get_characters();
	
	var p_index = 0;
	var ia_index = 0;
	for i in range(characters.size()):
		if characters[i]._get_tag() == "Player":
			characters[i].texture = player_texture;
			characters[i].position = player_pos[p_index];
			p_index += 1;
		elif characters[i]._get_tag() == "IA":
			characters[i].texture = enemy_texture;
			characters[i].position = ia_pos[ia_index];
			ia_index += 1;	
	
	
	pass;