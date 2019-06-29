extends Node

var newGame = true;
var started = false;

var player_pos;
var backgrounds = ['background0', 'background1', 'background3'];

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
		var r = randi() % backgrounds.size();
		var audiostream = load('res://Music/'+ backgrounds[r] + '.wav');
		$Background1.set_stream(audiostream);
		$Background1.play();

func playButtonSound():
	$Button.play();

func playIslandMenuSound():
	$IslandMenu.play();
	
func _get_started():
	return started;

func _set_started(state):
	started = state;

func _on_Background1_finished():
	var r = randi() % backgrounds.size();
	var audiostream = load('res://Music/'+ backgrounds[r] + '.wav');
	$Background1.set_stream(audiostream);
	$Background1.play();

func playWind():
	if($Wind.playing == false):
		$Wind.play();