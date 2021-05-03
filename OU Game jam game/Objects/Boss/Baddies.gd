extends StaticBody2D

const PROJECTILE = preload("res://Objects/EnemyProjectile/EnemyProjectile.tscn")

export var hp = 5
export var TIME = .3

onready var timer = $Timer
onready var aim = [$Node2D/Aim1, $Node2D/Aim2, $Node2D/Aim3, $Node2D/Aim9, $Node2D/Aim10, 
$Node2D/Aim11, $Node2D/Aim12, $Node2D/Aim13, $Node2D/Aim14, $Node2D/Aim15]

signal took_damage
signal dead

func _ready():
	#print(aim[rand_range(0, aim.size() - 1].global_position)
	randomize()
	timer.start(TIME)

func death():
	#print("dead")
	queue_free()

func _on_Hurtbox_area_entered(area):
	hp -= 1
	#print("boss: ow")
	emit_signal("took_damage")
	if hp <= 0:
		emit_signal("dead")
		death()

func _on_Timer_timeout():
	shoot(aim[rand_range(0, aim.size() - 1)].get_global_position() - global_position)
	#print(aim[rand_range(0, aim.size() - 1)].global_position)
	
func shoot(direction):
	var projectile = PROJECTILE.instance()
	projectile.accelerate(direction)
	get_parent().add_child(projectile)
	projectile.global_position = global_position

