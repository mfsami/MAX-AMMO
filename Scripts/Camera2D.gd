extends Camera2D

# Variables for camera shake
var shakeAmount: float = 0
var defaultOffset: Vector2 = offset
var posX : int
var posY : int

@onready var timer: Timer = $Timer
@onready var tween: Tween = create_tween()
@onready var player = $".."


# Variables for camera mouse lean
const MAX_DISTANCE = 250
var target_distance = 0 #Distance from the player to the point the camera is centerd at
var center_pos = position


func _ready():
	set_process(true)
	randomize()



func _process(delta):
	var camera = Camera2D
	offset = Vector2(randf_range(-1, 1) * shakeAmount, randf_range(-1, 1) * shakeAmount)
	
	# get the direction from the player to the mouse
	var direction = center_pos.direction_to(get_local_mouse_position())
	#The target posittion that our actual camera needs to go to
	var target_pos = center_pos + direction * target_distance
	
	target_pos = target_pos.clamp	(center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE))
	
	position = target_pos

	
func _input(event):
			
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2
		
	
	
	
func shake(time: float, amount: float):
	timer.wait_time = time
	shakeAmount = amount
	set_process(true)
	timer.start()
	

func _on_timer_timeout():
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, tween.TRANS_LINEAR, tween.EASE_IN)
