extends Node


export(int) var islands_count;

var newGame = true;
var started = false;

var player_pos;
var backgrounds = ['background0', 'background1', 'background3'];

var island_states = [];

func _ready():
	player_pos = Vector2(-40, 530);
	
	for i in range(islands_count):
		island_states.append(true);
	
	_get_data();
	
	pass

func endGame():
	#avengers -_-
	get_tree().change_scene('res://EndGame.tscn');

func setLoadGame():
	newGame = false;

func setNewGame():
	newGame = true;
	_clear_states();

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
func stopBack():
	$Background1.stop();

func playBattleB():
	$Background1.stop();
	$Wind.stop();
	$BattleMusic.play();

func stopBattleB():
	$BattleMusic.stop();

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

func playThunder():
	$Thunder.play();
	#yield(get_tree().create_timer(5.0),"timeout");
	#$Thunder.stop();
func stopThunder():
	$Thunder.stop();

func playNormalAt():
	yield(get_tree().create_timer(0.5),"timeout");
	$AtNormal.play();

func playSpecialAt():
	$AtSpecial.play();
	yield(get_tree().create_timer(1.3),"timeout");
	$AtSpecial.play();

func playHeal():
	$Heal.play();

func playHit():
	$Hit.play();

func _set_island_state(index, state):
	island_states[index] = state;
	_save_data();
	pass;

func _get_island_state(index):
	return island_states[index];

func _save_data():
	
	var save_game = File.new();
	
	save_game.open("res://globalsave.json", File.WRITE);
	
	var json_data = {"islands_state": island_states}

	save_game.store_line(to_json(json_data));
		
	save_game.close();
	
	pass;

func _get_data():
	
	var save_game = File.new();
	
	if not save_game.file_exists("res://globalsave.json"):
		print("file does not exists");
		return;
		
	save_game.open("res://globalsave.json", File.READ)
	
	var current_line =  parse_json(save_game.get_line());

	for i in range(islands_count):
		island_states[i] = current_line["islands_state"][i];
	
	save_game.close();
	
	pass;

func _clear_states():
	for i in range(islands_count):
		island_states[i] = true;
	pass;