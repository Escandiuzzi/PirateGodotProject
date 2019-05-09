extends Node2D

var playerPirates = [];
var enemies = []
var characters = [];

var playerCount;
var enemiesCount;

var battle;
var played;
var pos;
var target_enemy;

var player_action;

onready var pirateObj = preload("res://Pirate.tscn");
onready var battleScene = get_tree().get_root();

export(Array) var player_pos;
export(Array) var ia_pos;

var player_texture = load("res://Sprite/characters/idle_warrior.png");
var enemy_texture = load("res://Sprite/characters/idle_mimic.png");

func _ready():
	 pos = 0;


func _initializeEnemies(var enemies_n):
	enemiesCount = enemies_n;
	
	var pos = playerCount;
	
	var count = playerCount + enemies_n;
	
	for i in range(enemiesCount):
		characters.append(null);
		enemies.append(null);
		var newEnemy = pirateObj.instance();
		newEnemy._initializePirate();
		newEnemy._set_tag(1);
		battleScene.add_child(newEnemy);
		enemies[i] = newEnemy
		characters[pos] = newEnemy;
		pos += 1;
		newEnemy.position = ia_pos[i];
		newEnemy._change_sprite(enemy_texture);
	battle = true
	pass;

func _process(delta):
	if battle:
		if playerPirates.size() > 0 and enemies.size() > 0:
			var current_character = characters[pos];
			
			if current_character._get_tag() == "Player":
				if played:
					_player_action();
			
			elif current_character._get_tag() == "IA":
				_ia_action();
			
		else:
			battle = false;
	pass;

func _player_action():
	pass;

func _ia_action():
	pass;

func _get_characters():
	return characters;
	pass;

func _get_p_characters():
	return playerPirates;
	pass;

func _get_ia_characters():
	return enemies;
	pass;

func _instanciate_player_pirates(ids):
	var save_game = File.new();
	if not save_game.file_exists("res://savegame.json"):
		print("file does not exists");
		return;
		
	save_game.open("res://savegame.json", File.READ)
	
	var current_line =  parse_json(save_game.get_line());
		
	for i in range(ids.size()):
		characters.append(null);
		playerPirates.append(null);
		var newPirate = pirateObj.instance();
		characters[i] = newPirate;
		playerPirates[i] = newPirate;
		battleScene.add_child(newPirate);
		newPirate._setData(i, current_line[str(ids[i])]["tag"], current_line[str(ids[i])]["hp"], current_line[str(ids[i])]["maxHp"], current_line[str(ids[i])]["attack"], current_line[str(ids[i])]["defense"], current_line[str(ids[i])]["speed"], current_line[str(ids[i])]["mining"], current_line[str(ids[i])]["cooking"]);
		newPirate.position = player_pos[i];
		newPirate._change_sprite(player_texture);

	save_game.close();
	playerCount = ids.size();
	_initializeEnemies(3);
	pass;

func _player_button_action(action, target):
	played = true;
	player_action = action;
	target_enemy = target;
	pass;

