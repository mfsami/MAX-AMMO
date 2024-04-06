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


# Variables for camera zoom

var notZoomed = Vector2(1, 1)
var zoomed = Vector2(2, 2)
var zoomTargetPosition : Vector2
var isZoomed = false



func _ready():
	zoom = notZoomed
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
	
	if isZoomed:
		position = position.lerp(zoomTargetPosition, delta * 5)
	
	else:
		position = position.lerp(Vector2.ZERO, delta * 5)
	
func _input(event):
	
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			zoom_to_mouse()
			isZoomed = true
			
		elif event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
			zoom = notZoomed
			isZoomed = false
			position = Vector2.ZERO
			
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2
		
func zoom_to_mouse():
	zoom = zoomed
	# Calculate the target position for the zoom
	var mouse_in_world = get_global_mouse_position()
	var player_pos = player.global_position
	zoomTargetPosition = player_pos.lerp(mouse_in_world, 0.5) - player_pos
	
	
	
func shake(time: float, amount: float):
	timer.wait_time = time
	shakeAmount = amount
	set_process(true)
	timer.start()
	

func _on_timer_timeout():
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, tween.TRANS_LINEAR, tween.EASE_IN)
