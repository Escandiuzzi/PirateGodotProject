extends Node

var newGame = true;


func _ready():
	pass # Replace with function body.

func setLoadGame():
	newGame = false;
func setNewGame():
	newGame = true;
func getGame():
	return newGame;