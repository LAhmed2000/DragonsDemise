extends Control

onready var life = $Life
onready var player = get_node("../YSort/Player")

func _ready():
	life.rect_size.x = 16 * player.hp
	player.connect("took_damage", self, "lower_health_bar")

func lower_health_bar():
	life.rect_size.x -= 16
	

