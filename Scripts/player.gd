extends CharacterBody2D

const SPEED = 420
@onready var ray_cast_2d = $RayCast2D
var shoot_rate = 0.2  # Time in seconds between shots
var time_since_last_shot = 0.0  # Timer to track time since last shot
@onready var camera_2d = $Camera2D

# Movement
#TEDSTING

func _physics_process(delta):
	
	# Easier than expliciy calling vector value on each dierction seperatley, this is all done in one line instead
	
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	move_and_slide()
	
	# Character points to mouse position
	
	global_rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI / 2.0
	
# Player death
func kill():
	get_tree().reload_current_scene()
	
func _process(delta):
	# Reduce the cooldown timer if there's time left on it.
	if time_since_last_shot > 0.0:
		time_since_last_shot -= delta

	# Check if the shoot button is being held down.
	if Input.is_action_pressed("Shoot") and time_since_last_shot <= 0.0:
		shoot()
		time_since_last_shot = shoot_rate  # Reset the timer for the next shot.

func shoot():
	# Check if the raycast is colliding with something
	
	$MuzzleFlash.show()
	$MuzzleFlash/Timer.start()
	
	camera_2d.shake(0.2, 3)
	
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		if collider and collider.has_method("take_damage"):
			collider.take_damage()  # Deal damage to the collider
		

	
	
