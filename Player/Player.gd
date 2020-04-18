extends Area2D


# Signals
signal hit


# Variable
export var speed = 400  # How fast the player will move.
var screen_size: Vector2  # Size of the game window


# Signal handling
func _on_Player_body_entered(body):
	emit_signal("hit")
	kill()


# Process functions
func start(pos: Vector2):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func kill():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)


func _process_animation(velocity: Vector2):
	if velocity.length() > 0:
		if velocity.x != 0:
			$AnimatedSprite.animation = "right"
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite.animation = "up"
			$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()


func _process_movement(delta: float, velocity: Vector2):
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _process_velocity() -> Vector2:
	var velocity = Vector2()
	# Horizontal movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	# Vertical movement
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	# Normalize vector
	return velocity.normalized() * speed


# Callbacks
func _process(delta: float):
	var velocity = _process_velocity()
	_process_animation(velocity)
	_process_movement(delta, velocity)


func _ready():
	screen_size = get_viewport_rect().size
