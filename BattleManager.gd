extends Node2D

var playerCount;
var enemiesCount;

var nEnemies;
var difficulty;

func _island_data(_difficulty, _nEnemies):
	difficulty = _difficulty;
	nEnemies = _nEnemies;
	pass;
	
func _request_island_data():
	var island_data = [nEnemies, difficulty];
	return island_data;
	pass;