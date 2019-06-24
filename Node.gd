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

func playMenuMusic():
	if($MenuMusic.playing == false):
		$MenuMusic.play();

func stopMenuMusic():
	if($MenuMusic.playing == true):
		$MenuMusic.stop();

func playBackground1():
	if($Background1.playing == false):
		$Background1.play();