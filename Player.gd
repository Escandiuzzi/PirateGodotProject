extends Sprite

# Speed at which the sidekick will move

export(int) var MOVEMENT_SPEED;

# How close the sidekick must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 5

# Path that the sidekick must follow - undefined by default
var path

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

# Performed on each step
func _process(delta):

	# Only do stuff if we have a current path
	if path:

		# The next point is the first member of the path array
		var target = path[0]

		# Determine direction in which sidekick must move
		var direction = (target - position).normalized()

		# Move sidekick
		position += direction * MOVEMENT_SPEED * delta

		# If we have reached the point...
		if position.distance_to(target) < POINT_RADIUS:

			# Remove first path point
			path.remove(0)

			# If we have no points left, remove path
			if path.size() == 0:
				path = null

	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
