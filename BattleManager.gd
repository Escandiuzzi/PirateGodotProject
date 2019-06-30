extends Node2D

var playerCount;
var enemiesCount;

var nEnemies;
var difficulty;
var region;
var island_type
var indexType;
var common_size;
var uncommon_size;
var rare_size;
var max_rewards;
var scenePath;
var is_bossIsland;
var island_id;

func _island_data(_difficulty, _nEnemies, _region, _indexType, _common_size, _uncommon_size, _rare_size, _max_rewards, _island_type, _scenePath, _is_boss, _island_id):
	difficulty = _difficulty;
	nEnemies = _nEnemies;
	region = _region;
	indexType = _indexType;
	common_size = _common_size;
	uncommon_size = _uncommon_size;
	rare_size = _rare_size;
	max_rewards = _max_rewards;
	island_type = _island_type;
	scenePath = _scenePath;
	is_bossIsland = _is_boss;
	island_id = _island_id;
	pass;
	
func _request_island_data():
	var island_data = [nEnemies, difficulty, region, indexType, common_size, uncommon_size, rare_size, max_rewards, island_type, scenePath, is_bossIsland, island_id];
	return island_data;
	pass;