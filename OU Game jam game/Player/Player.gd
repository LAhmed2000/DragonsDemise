extends KinematicBody2D

const PROJECTILE = preload("res://Objects/PlayerProjectile/Projectile.tscn")

export var max_speed = 100
export var acceleration = 400
export var friction = 350
export var hp = 5
export var max_ammo = 3
export var attack_speed = .5

enum {
	MOVE,
	SHOOT,
	RELOAD
}

var velocity = Vector2.ZERO
var state = MOVE
var ammo = max_ammo

onready var shooter_position = $Shooter
onready var sprite = $Sprite
onready var anim_sprite_walk_right = $AnimSprites/WalkRight
onready var anim_sprite_walk_left = $AnimSprites/WalkLeft
onready var anim_sprite_attack_right = $AnimSprites/AttackRight
onready var anim_sprite_attack_left = $AnimSprites/AttackLeft
onready var timer = $Timer

signal took_damage
signal dead
signal fired
signal reload

func _physics_process(delta):
	match state:
		MOVE:
			move_player(delta)
		SHOOT:
			shoot()
		RELOAD:
			reload()
	

func move_player(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		sprite.flip_h = velocity.x > 0
		play_walk_anim()
	else:
		play_idle_anim()
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)	
	move()
	
	if Input.is_action_just_pressed("left_click"):
		state = SHOOT
		
	if Input.is_action_just_pressed("right_click"):
		state = RELOAD
	
func move():
	velocity = move_and_slide(velocity)
	
func shoot():
	if ammo > 0:
		play_attack_anim()
		spawn_projectile(get_local_mouse_position())
		ammo -= 1;
		emit_signal("fired")
	state = MOVE
		#timer.start(attack_speed)
	
func reload():
	ammo = max_ammo
	emit_signal("reload")
	state = MOVE
	
func spawn_projectile(direction):
	var projectile = PROJECTILE.instance()
	projectile.accelerate(direction)
	get_parent().add_child(projectile)
	projectile.global_position = shooter_position.global_position

func lower_health_bar():
	emit_signal("took_damage")
	
func play_walk_anim():
	hide_all_anim()
	if velocity.x > 0:
		anim_sprite_walk_right.visible = true
	elif velocity.x <= 0:
		anim_sprite_walk_left.visible = true
		
func play_idle_anim():
	hide_all_anim()
	sprite.visible = true
	
func play_attack_anim():
	hide_all_anim()
	var direction = get_local_mouse_position().x
	if direction > 0:
		anim_sprite_attack_right.visible = true
	elif direction <= 0:
		anim_sprite_attack_left.visible = true
		
func hide_all_anim():
	sprite.visible = false
	anim_sprite_walk_left.visible = false
	anim_sprite_walk_right.visible = false
	anim_sprite_attack_left.visible = false
	anim_sprite_attack_right.visible = false

func _on_Hurtbox_area_entered(area):
	hp -= 1
	lower_health_bar()
	if hp <= 0:
		emit_signal("dead")
		queue_free()


func _on_Timer_timeout():
	state = MOVE
