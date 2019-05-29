extends Node2D

onready var b_log = $BattleLog;

var playerPirates = [];
var enemies = []
var characters = [];

var playerCount;
var enemiesCount;

var battle;
var played;
var pos;
var target_enemy;
var island_type;
var player_action;
var nEnemies;
var difficulty;
var region;
var indexType;
var common_size;
var uncommon_size;
var rare_size;
var max_rewards;
var scenePath;
var current_character;
var special_id;
var energy_turn = 2;
var item_selected;
var turn = 0;

onready var recruitPanel = get_node("RecruitPirate");
onready var ui_handler = get_node("Manager/UI/UIButtonHandler");
onready var manager = $Manager;
onready var rewardText = get_node("Panel/RewardsText");
onready var panel = get_node("Panel");
onready var pirateObj = preload("res://Pirate.tscn");
onready var item = preload("res://Item.tscn");

onready var player_data = get_tree().get_root().get_node("/root/PlayerData");
onready var battle_manager = get_tree().get_root().get_node("/root/BattleManager");

onready var turnText = $TurnText;

export(Array) var player_pos;
export(Array) var ia_pos;

var player_texture = load("res://Sprite/characters/idle_warrior.png");
var enemy_texture = load("res://Sprite/characters/idle_mimic.png");


func _ready():
	pos = 0;
	player_data._request_player_pirates();
	pass;

func _initializeEnemies():
	
	var island_data = battle_manager._request_island_data();
	nEnemies = island_data[0];
	difficulty = island_data[1];
	region = island_data[2];
	indexType = island_data[3];
	common_size = island_data[4];
	uncommon_size = island_data[5];
	rare_size = island_data[6];
	max_rewards = island_data[7];
	island_type = island_data[8];
	scenePath = island_data[9];
	
	enemiesCount = nEnemies;
	
	var pos = playerCount;
	
	var count = playerCount + nEnemies;
	
	var z_layer = 3;
	
	for i in range(enemiesCount):
		characters.append(null);
		enemies.append(null);
		var newEnemy = pirateObj.instance();
		newEnemy._initializePirate();
		newEnemy._set_tag(1);
		self.add_child(newEnemy);
		enemies[i] = newEnemy
		characters[pos] = newEnemy;
		pos += 1;
		newEnemy.position = ia_pos[i];
		newEnemy._change_sprite(enemy_texture);
		newEnemy._instantiate_special();
		newEnemy.z_index = z_layer;
		z_layer-=1;
	battle = true
	pass;

func _process(delta):
	if Input.is_action_pressed("key_c"):
		b_log.text = "";
	
	if Input.is_action_pressed("ui_left"):
		for i in range(playerPirates.size()):
			playerPirates[i]._set_hp(0);
		playerPirates.clear();
	
	if battle:
		if playerPirates.size() > 0 and enemies.size() > 0:
			current_character = characters[turn];
			if current_character._get_tag() == "Player":
				if played:
					_player_action();
			
			elif current_character._get_tag() == "IA":
				_ia_action();
			
		else:
			battle = false;
			
			ui_handler._layers_visible(false);
			
			if playerPirates.size() > 0:
				_get_player_rewards();
				
				for i in range(characters.size()):
					if characters[i]._get_hp() > 0 and characters[i]._get_tag() == "Player":
						playerPirates[i]._set_post_battle_bonus(12);
						playerPirates[i]._set_busy(false);
				
				_remove_dead_pirates();
				
			else:
				_remove_dead_pirates();
				get_tree().change_scene(scenePath);
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
		var damage = special_attack._get_stat("damage");
		var heal =  special_attack._get_stat("heal");
		var energy = special_attack._get_stat("energy");
		var attack_range = special_attack._get_stat("range");
		
		var energy_loss = current_character._get_energy() - int(energy);
		current_character._set_energy(energy_loss);
		
		if heal > 0 and attack_range == 1:
			current_character._set_hp(heal + current_character._get_hp());
		elif heal > 0 and int(attack_range) > 1:
			_heal_partners(playerPirates, attack_range, heal);
			
		if damage > 0:
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
	
	elif player_action == "Inventory":
		var heal = item_selected[0];
		var damage = item_selected[1];
		var durability = item_selected[2];
		
		current_character._set_hp(current_character._get_hp() + heal);
		current_character._set_stat("atk", damage);

	target_enemy = null;
	player_action = null;
	played = false;
	item_selected = null;
	
	_next_turn();
	
	pass;

func _ia_action():
	OS.delay_msec(3000);
	
	randomize();
	var ia_action = randi() % 2;
	if ia_action == 0:
		_ia_attack_player();
	
	elif ia_action == 1:
		#check energy available--------------------
		var special_ids = [];
		var pos = 0;
		for i in range(4):
			if current_character._get_energy() >= current_character._get_special_attack(i)._get_stat("energy"):
					special_ids.append(null);
					special_ids[pos] = i;
					pos+=1;
		
		#special attack 
		if special_ids.size() > 0:
			
			randomize();
			var special_index = randi() % special_ids.size();
			
			var special_attack = current_character._get_special_attack(special_ids[special_index]);
			var damage = special_attack._get_stat("damage");
			var heal =  special_attack._get_stat("heal");
			var energy = special_attack._get_stat("energy");
			var attack_range = special_attack._get_stat("range");
			
			var energy_loss = current_character._get_energy() - energy;
			current_character._set_energy(energy_loss);
			
			
			b_log.text += str(turn) + " Special cost " + str(energy) + " with damage of " + str(damage) + ", heal of " + str(heal) + " and range of " + str(attack_range)  + ";" + "\n";
			
			if  heal> 0 and attack_range== 1:
				current_character._set_hp(int(heal) + current_character._get_hp());	
			
			elif heal> 0 and attack_range > 1:
				_heal_partners(enemies, attack_range, heal);
			
			if damage > 0:
				randomize();
				var target_player = randi() % playerPirates.size(); 
				
				if int(attack_range) == 1:
					_attack_one_character(damage, playerPirates, target_player, playerCount);
				elif int(attack_range) == 2:
					if playerPirates.size() > 1:
						_attack_two_characters(damage, playerPirates, target_player, playerCount);
					else:
						_attack_one_character(damage, playerPirates, target_player, playerCount);
				elif int(attack_range) == 3:
					if playerPirates.size() == 3:
						_attack_three_characters(damage, playerPirates, target_player, playerCount);
					elif playerPirates.size() == 2:
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
		self.add_child(newPirate);
		newPirate._setData(ids[i], current_line[str(ids[i])]["tag"], current_line[str(ids[i])]["hp"], current_line[str(ids[i])]["maxHp"], current_line[str(i)]["energy"], current_line[str(i)]["maxEnergy"], current_line[str(ids[i])]["attack"], current_line[str(ids[i])]["mining"], current_line[str(ids[i])]["cooking"], current_line[str(ids[i])]["special"] );
		newPirate.position = player_pos[i];
		newPirate._change_sprite(player_texture);
		newPirate._instantiate_special();
	save_game.close();
	playerCount = ids.size();
	player_data._readData(1);
	_initializeEnemies();
	
	pass;

func _player_button_action(action, target, id, item):
	played = true;
	player_action = action;
	target_enemy = target;
	special_id = id;
	item_selected = item;
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
	if characters[turn]._get_hp() <= 0:
		ui_handler._layers_visible(false);
		_next_turn();
	else:
		if characters[turn]._get_tag() == "IA":
			ui_handler._layers_visible(false);
		else:
			ui_handler._layers_visible(true);
		turnText.text = "Turn: " + str(turn);
		print(str(turn));
		print("current energy" + str(characters[turn]._get_energy()));
		characters[turn]._set_energy(characters[turn]._get_energy() + energy_turn);
		print("updated energy" + str(characters[turn]._get_energy()));
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
	
	b_log.text += str(turn) + " Attack of damage " + str(damage) + " on enemy with index of " + str(target_p) + ";" + "\n";
	
	_check_enemy_life(playerPirates[target_p], playerCount, playerPirates, target_p);
	pass;
	

func _heal_partners(array, heal_range, heal):
	
	if heal_range == 3:
		_heal_crew(array, heal_range, heal);
	elif heal_range == 2 and array.size() > 2:
		_heal_two_characters(array, heal_range, heal);
	else:
		_heal_crew(array, heal_range, heal);
	pass;


func _heal_crew(array, heal_range, heal):
	for i in range(array.size()):
		if array[i] == current_character:
			current_character._set_hp(int(heal) + current_character._get_hp());
		else:
			array[i]._set_hp(int(heal)/2 + current_character._get_hp());
	pass;

func _heal_two_characters(array, heal_range, heal):
	
	var count = 0;
	var c_character = false;
	
	for i in range(array.size()):
		if array[i] == current_character:
			current_character._set_hp(int(heal) + current_character._get_hp());
			count += 1;
			c_character = true;
		elif count <= 1:
			array[i]._set_hp(int(heal)/2 + current_character._get_hp());
		
		if count == 2:
			break;
		
	pass;

func _check_enemy_life(enemy, count, array, target):
	if enemy._get_hp() <= 0:
		if enemy._get_tag() == "IA":
			ui_handler._ia_defeated();
			manager._remove_healthbar(1, target);
		else:
			manager._remove_healthbar(0, target);
			
		count -= 1;
		enemy.visible = false;
		array.erase(enemy);
	pass;

func _get_player_rewards():
	panel.visible = true;
	randomize();
	var rewardN = randi() % max_rewards + 1;
	var rewards = {};
	for i in range(rewardN):
		#/////////////////////////////////////////
		var rarity = randi() % 100;
		var _item = item.instance();

		if rarity >= 90:
			var randReward = randi() % rare_size;
			_item._read_json_data(randReward, region, "Rare", island_type);
			_item._print_data();
		elif rarity >= 60 and rarity < 90:
			var randReward = randi() % uncommon_size;
			_item._read_json_data(randReward, region, "Uncommon", island_type);
			_item._print_data();
		elif rarity < 60:
			var randReward = randi() % common_size;
			_item._read_json_data(randReward, region, "Common", island_type);
			_item._print_data();
		
		if rewards.has(_item._get_name()):
			var item_count = rewards[_item._get_name()];
			item_count += 1;
			rewards[_item._get_name()] = item_count;
		else:
			rewards[_item._get_name()] = 1;
		
		#rewardText.text += _item._get_name();
		#rewardText.text += "\n";
		player_data._receive_player_reward(_item);
		#/////////////////////////////////////////
		
	var keys = rewards.keys();
	for i in range(rewards.size()):
		rewardText.text += str(rewards[keys[i]]);
		rewardText.text += "x ";
		rewardText.text += keys[i];
		rewardText.text += "\n";
	rewardText.visible = true;
	pass;

func _remove_dead_pirates():
	for i in range(characters.size()):
		if characters[i]._get_tag() == "Player" and characters[i]._get_hp() <= 0:
			player_data._remove_pirate(characters[i]);
	player_data._saveData();
	pass;

func _on_RecruitButton_pressed():
	player_data._recruitPirate(1);
	self.visible = false;
	player_data._saveData();
	get_tree().change_scene(scenePath);
	pass