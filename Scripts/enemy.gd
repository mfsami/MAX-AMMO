extends CharacterBody2D

@onready var ray_cast_2d = $RayCast2D
const SPEED = 100
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
var dead = false
var damage = 1
var health = 1

func _physics_process(delta):
	if dead:
		return
	
	var dir_to_player = global_position.direction_to(player.global_position)
	velocity = dir_to_player * SPEED
	move_and_slide()
	
	global_rotation = dir_to_player.angle() + PI / 2.0
	
	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() == player:
		player.kill()

func take_damage():
	health -= damage
	if health <= 0 and not dead:
		kill()
	
func kill():
	dead = true
	queue_free()
