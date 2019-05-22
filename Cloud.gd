extends Node2D
export(int) var initial_pos;
export(int) var final_pos;
export(float) var speed;


func _ready():
	pass;

func _process(delta):
	
	position += Vector2(speed, 0);
	
	
	if(get_global_position()[0] > final_pos):
		position.x = initial_pos;
	
	pass;