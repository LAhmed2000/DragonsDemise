extends KinematicBody2D

export var max_speed = 100

var velocity = Vector2.ZERO

func _physics_process(delta):
	move()
	
func move():
	velocity = move_and_slide(velocity)
	
func accelerate(aim):
	var direction = global_position.direction_to(aim)
	velocity = velocity.move_toward(direction * max_speed, max_speed)

func _on_Hitbox_body_entered(body):
	#print("works")
	queue_free()
