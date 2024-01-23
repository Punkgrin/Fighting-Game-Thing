extends CharacterBody2D

var slash_scene = preload("res://scenes/slash.tscn")

const SPEED = 500.0
const JUMP_VELOCITY = -800.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var jump_token = 1

func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if is_on_floor():
		$CoyoteTimer.start(0.15)
		jump_token = 1
	if Input.is_action_just_pressed("jump") && !$CoyoteTimer.is_stopped() && jump_token == 1:
		velocity.y = JUMP_VELOCITY
		jump_token = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horiz_direction = Input.get_axis("left", "right")
	var vert_direction = Input.get_axis("up", "down")
	if horiz_direction:
		velocity.x = horiz_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("attack"):
		var slash = slash_scene.instantiate()
		slash.position.x = horiz_direction * 100
		slash.position.y = vert_direction * 100
		add_child(slash)
		$Cooldown.start()
		
	print($CoyoteTimer.time_left)

	move_and_slide()
