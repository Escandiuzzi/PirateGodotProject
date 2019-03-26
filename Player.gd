extends Sprite

# Speed at which the sidekick will move

export(int) var MOVEMENT_SPEED;

# How close the sidekick must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 5;

# Path that the sidekick must follow - undefined by default
var path;
var crewCount = 0;
var crew = [];


onready var pirateObj = preload("res://Pirate.tscn");

func _ready():
	for i in range(10):
		crew.append(null);
	pass

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo and crewCount < 10:
		_recruitPirate();
	pass;

func _recruitPirate():
	var newPirate = pirateObj.instance();
	var newPos = Vector2(position.x - 33, position.y + (crewCount * 54));
	newPirate.position = newPos;
	crew[crewCount] = newPirate;
	newPirate._setId(crewCount);
	crewCount += 1;
	add_child(newPirate);
	pass;

# Performed on each step
func _process(delta):
	
	# Only do stuff if we have a current path
	if path:

		# The next point is the first member of the path array
		var target = path[0];

		# Determine direction in which sidekick must move
		var direction = (target - position).normalized();

		# Move sidekick
		position += direction * MOVEMENT_SPEED * delta;

		# If we have reached the point...
		if position.distance_to(target) < POINT_RADIUS:

			# Remove first path point
			path.remove(0);

			# If we have no points left, remove path
			if path.size() == 0:
				path = null;

	pass;

func _saveData():
	var save_nodes = get_tree().get_nodes_in_group("Persist");
	for i in save_nodes:
		var a;
	pass;


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
