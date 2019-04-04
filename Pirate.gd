extends Node2D

var special = [];
var id;
var busy;
onready var pirateStat = get_node("pirateStat");


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _initializeArray():
	for i in range(3):
		special.append(null);
	pass;

func _initializePirate():
	_initializeArray();
	print("New Pirate created with: ")
	for i in range(3):
		randomize();
		var r = randi() & 100; 
		if r  > 87: #rare pirate
			var s = randi() % 9 + 1;
			print(s);
			special[i] = s;	
		else: #common pirate
			var s = randi() % 4;
			print(s);
			special[i] = s;	
	pass
	
func _setId(_id):
	id = _id;
	pass;

func _savePirate():
	var save_dict = {
		"id" : id,
		"mining" : special[0],
		"battle" : special[1],
		"cooking" : special[2]
		}
	return save_dict;

func _setData(_id, mining, battle, cooking):	
	id = _id;
	_initializeArray();
	special[0] = mining;
	special[1] = battle;
	special[2] = cooking;
	print("updating data")
	print(special[0]);
	print(special[1]);
	print(special[2]);
	pass; 

func _get_special(index):
	return special[index];
	pass;

func _set_busy(status):
	busy = status;
	pass;
func _get_busy():
	return busy;

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _on_Area2D_mouse_entered():
	pirateStat.text = "";
	pirateStat.text += "Mining: " + str(_get_special(0)) + "\n";
	pirateStat.text += "Battle: " + str(_get_special(1)) + "\n";	
	pirateStat.text += "Cooking: " + str(_get_special(2)) +"\n";
	pirateStat.show();
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	pirateStat.hide();
	pass # Replace with function body.
