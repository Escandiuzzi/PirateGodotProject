extends Node

var newGame = true;

var player_pos;


func _ready():
	player_pos = Vector2(-40, 530);
	pass

func setLoadGame():
	newGame = false;

func setNewGame():
	newGame = true;

func getGame():
	return newGame;

func _set_player_coordinates(pos):
	player_pos = pos;

func _get_player_coordinates():
	return player_pos;