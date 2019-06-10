extends Camera2D

enum MODES {
	MODE_PLAYER,
	MODE_FOLLOW,
	MODE_RETURN
	};

const POINT_RADIUS = 1;

export(float) var speed;

onready var player = get_parent().get_node("Player");

var target;
var mode

func _ready():
	mode = MODES.MODE_PLAYER;
	pass;

func _process(delta):
	if mode == MODES.MODE_PLAYER:
		position = player.position;
	
	elif mode == MODES.MODE_FOLLOW:
		var direction = (target.position - position).normalized();
		position += direction * speed * delta;
		
		if position.distance_to(target.position) < POINT_RADIUS:
			mode = null;
			target = null;
			
	elif mode == MODES.MODE_RETURN:
		var direction = (player.position - position).normalized();
		position += direction * speed * delta;
		
		if position.distance_to(player.position) < POINT_RADIUS:
			mode = MODES.MODE_PLAYER;
	pass;


func follow(_target):
	mode = MODES.MODE_FOLLOW;
	target = _target;
	pass;

func return_to_player():
	mode = MODES.MODE_RETURN;
	pass;