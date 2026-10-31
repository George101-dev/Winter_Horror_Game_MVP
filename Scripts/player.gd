extends CharacterBody2D

const SPEED = 300.0
var is_in_dialogue: bool = false
var is_in_cutscene: bool = false


func _physics_process(delta: float) -> void:
	
	if is_in_dialogue:
		velocity = Vector2.ZERO # Stop all existing momentum instantly
		move_and_slide()
		return #The code below this line will be completely ignored.
		
	if is_in_cutscene:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	if direction_x:
		velocity.x = direction_x * SPEED
		velocity.y = 0
	elif direction_y:
		velocity.y = direction_y * SPEED
		velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
