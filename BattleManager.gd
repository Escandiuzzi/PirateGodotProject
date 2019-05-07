extends Node2D

var playerPirates = [];
var enemies = []
var characters = [];

var playerCount;
var enemiesCount;

var battle;
var played;

var target_enemy;

var player_action;

onready var pirateObj = preload("res://Pirate.tscn");

func _initializeBattle(var player_n, var enemies_n, var pirates):
	playerCount = player_n;
	enemiesCount = enemies_n;
	
	var pos = 0;
	
	var count = player_n + enemies_n;
	for i in range(count):
		characters.append(null);
		playerPirates.append(null);
		enemies.append(null);
	for i in range(playerCount):
		characters[pos] = pirates[i];
		playerPirates[i] = pirates[i];
		self.add_child(playerPirates[i]);
		pos += 1;
	
	for i in range(enemiesCount):
		var newEnemy = pirateObj.instance();
		newEnemy._initializePirate();
		newEnemy._set_tag(1);
		self.add_child(newEnemy);
		enemies[i] = newEnemy
		characters[pos] = newEnemy;
		pos += 1;
		#newEnemy.position = slot_positions[crewCount];
		#_battle();
		battle = true;
	pass;


func _battle():
	var pos = 0;
	while battle:
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


