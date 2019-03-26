extends Node2D

var special = [];
var id;

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	for i in range(3):
		special.append(null);
	_initializePirate();
	pass

func _initializePirate():
	print("New Pirate created with: ")
	for i in range(3):
		
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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
