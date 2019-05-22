extends Node2D

export(int) var final_pos;
export(float) var speed;

var initial_pos;

func _ready():
	
	initial_pos = get_global_position();
	pass;

func _process(delta):
	
	position += Vector2(speed, 0);
	
	
	if(get_global_position()[0] > final_pos):
		position = initial_pos;
	
	pass;