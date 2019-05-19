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
var nEnemies;
var difficulty;
var current_character;
var special_id;

var turn = 0;

var ui_handler;
var manager;

onready var pirateObj = preload("res://Pirate.tscn");
onready var battleScene = get_tree().get_root();

export(Array) var player_pos;
export(Array) var ia_pos;

var player_texture = load("res://Sprite/characters/idle_warrior.png");
var enemy_texture = load("res://Sprite/characters/idle_mimic.png");


func _ready():
	 pos = 0;

func _initializeEnemies(var enemies_n):
	
	ui_handler = get_tree().get_root().get_node("BattleScene/Manager/UI/UIButtonHandler");
	manager = get_tree().get_root().get_node("BattleScene/Manager");
	
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
		newEnemy._instantiate_special();
	battle = true
	pass;

func _process(delta):
	if battle:
		if playerPirates.size() > 0 and enemies.size() > 0:
			current_character = characters[turn];
			
			if current_character._get_tag() == "Player" and current_character._get_hp() > 0:
				if played:
					_player_action();
			
			elif current_character._get_tag() == "IA" and current_character._get_hp() > 0:
				_ia_action();
			
		else:
			battle = false;
	pass;

func _player_action():
	
	if player_action == "Attack":
		var damage = int(current_character._get_stat("atk"));
		
		randomize();
		var additional = randi() % 3;
		
		damage += additional;
		
		var enemy = enemies[target_enemy];
		
		enemy._set_hp(enemy._get_hp() - damage);
		_check_enemy_life(enemy, enemiesCount, enemies, target_enemy);
	
	elif player_action == "Special":
		var special_attack = current_character._get_special_attack(special_id);
		var damage = int(special_attack._get_stat("damage"));
		var heal =  special_attack._get_stat("heal");
		var energy = special_attack._get_stat("energy");
		var attack_range = special_attack._get_stat("range");
		
		var energy_loss = current_character._get_energy() - int(energy);
		current_character._set_energy(energy_loss);
		
		if int(heal) > 0:
			current_character._set_hp(int(heal) + current_character._get_hp());
		
		
		if int(attack_range) == 1:
			_attack_one_character(damage, enemies, target_enemy, enemiesCount);
		elif int(attack_range) == 2:
			if enemies.size() > 1:
				_attack_two_characters(damage, enemies, target_enemy, enemiesCount);
			else:
				_attack_one_character(damage, enemies, target_enemy, enemiesCount);
		elif int(attack_range) == 3:
			if enemies.size() == 3:
				_attack_three_characters(damage, enemies, target_enemy, enemiesCount);
			elif enemies.size() == 2:
				_attack_two_characters(damage, enemies, target_enemy, enemiesCount);
			else:
				_attack_one_character(damage, enemies, target_enemy, enemiesCount);
	
	#elif player_action == "Invetory":
	
	target_enemy = null;
	player_action = null;
	played = false;
	
	_next_turn();
	
	pass;

func _ia_action():
	
	randomize();
	var ia_action = randi() % 2;
	
	if ia_action == 0:
		_ia_attack_player();
	
	elif ia_action == 1:
		
		#check energy available--------------------
		var special_ids = [];
		var pos = 0;
		for i in range(4):
			var energy = int(current_character._get_special_attack(i)._get_stat("energy"));
			if current_character._get_energy() > energy:
						special_ids.append(null);
						special_ids[pos] = i;
						pos+=1;
		
		#special attack 
		if special_ids.size() > 0:
			var special_attack = current_character._get_special_attack(special_id);
			var damage = int(special_attack._get_stat("damage"));
			var heal =  special_attack._get_stat("heal");
			var energy = special_attack._get_stat("energy");
			var attack_range = special_attack._get_stat("range");
			
			var energy_loss = current_character._get_energy() - int(energy);
			current_character._set_energy(energy_loss);
			
			print("enemy special attack")
			
			if int(heal) > 0:
				current_character._set_hp(int(heal) + current_character._get_hp());
			
			randomize();
			var target_player = randi() % playerPirates.size(); 
			
			if int(attack_range) == 1:
				_attack_one_character(damage, playerPirates, target_player, playerCount);
			elif int(attack_range) == 2:
				if enemies.size() > 1:
					_attack_two_characters(damage, playerPirates, target_player, playerCount);
				else:
					_attack_one_character(damage, playerPirates, target_player, playerCount);
			elif int(attack_range) == 3:
				if enemies.size() == 3:
					_attack_three_characters(damage, playerPirates, target_player, playerCount);
				elif enemies.size() == 2:
					_attack_two_characters(damage, playerPirates, target_player, playerCount);
				else:
					_attack_one_character(damage, playerPirates, target_player, playerCount);
		else:
			_ia_attack_player();
		
		
	
	
	_next_turn();
	
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
		newPirate._setData(i, current_line[str(ids[i])]["tag"], current_line[str(ids[i])]["hp"], current_line[str(ids[i])]["maxHp"], current_line[str(i)]["energy"], current_line[str(i)]["maxEnergy"], current_line[str(ids[i])]["attack"], current_line[str(ids[i])]["mining"], current_line[str(ids[i])]["cooking"], current_line[str(ids[i])]["special"] );
		print(current_line[str(i)]["maxEnergy"]);
		newPirate.position = player_pos[i];
		newPirate._change_sprite(player_texture);
		newPirate._instantiate_special();
	save_game.close();
	playerCount = ids.size();
	_initializeEnemies(nEnemies);
	pass;

func _player_button_action(action, target, id):
	played = true;
	player_action = action;
	target_enemy = target;
	special_id = id;
	pass;

func _island_data(_difficulty, _nEnemies):
	difficulty = _difficulty;
	nEnemies = _nEnemies;
	pass;

func _get_current_character():
	return current_character;
	pass;

func _next_turn():
	turn += 1;
	
	if turn >= characters.size():
		turn = 0;
	
	if characters[turn]._get_tag() == "IA":
		ui_handler._layers_visible(false);
	else:
		ui_handler._layers_visible(true);
		
	pass;
	
func _attack_one_character(damage, array, target, count):
	var enemy = array[target];
	enemy._set_hp(enemy._get_hp() - damage);
	_check_enemy_life(enemy, count, array, target);
	pass;

func _attack_two_characters(damage, array, target, count):
	var enemy = array[target];
	enemy._set_hp(enemy._get_hp() - damage);
	_check_enemy_life(enemy, count, array, target);

	var second_enemy = target + 1
	if second_enemy >= array.size():
		target = 0;
	else:
		target += 1;
	enemy = array[target];
	enemy._set_hp(enemy._get_hp() - damage);
	_check_enemy_life(enemy, count, array, target);
	pass;

func _attack_three_characters(damage, array, target, count):
	var enemy = array[target];
	enemy._set_hp(enemy._get_hp() - damage);
	_check_enemy_life(enemy, count, array, target);

	var second_enemy = target + 1
	if second_enemy >= array.size():
		target = 0;
	else:
		target += 1;
	enemy = array[target];
	enemy._set_hp(enemy._get_hp() - damage);
	_check_enemy_life(enemy, count, array, target);
	
	var third_enemy = target + 1
	if third_enemy  >= array.size():
		target = 0;
	else:
		target += 1;
	enemy = array[target];
	enemy._set_hp(enemy._get_hp() - damage);
	_check_enemy_life(enemy, count, array, target);
	pass;

func _ia_attack_player():
	
	var target_p = randi() % playerPirates.size();
	var damage = current_character._get_stat("atk");
	
	randomize();
	var additional = randi() % 3;
	
	damage += additional;
	playerPirates[target_p]._set_hp(playerPirates[target_p]._get_hp() - damage);
	
	_check_enemy_life(playerPirates[target_p], playerCount, playerPirates, target_p);
	
	pass



func _check_enemy_life(enemy, count, array, target):
	if enemy._get_hp() <= 0:
		if enemy._get_tag() == "IA":
			ui_handler._ia_defeated();
			manager._remove_healthbar(1, target);
		else:
			manager._remove_healthbar(0, target);
			
		count -= 1;
		characters.erase(enemy);
		array.erase(enemy);
		enemy.queue_free();
	pass;
	
