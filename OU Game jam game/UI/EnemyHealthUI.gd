extends Control

onready var life = $Life
onready var boss = get_node("../Boss")

func _ready():
	life.rect_size.x = 16 * boss.hp
	boss.connect("took_damage", self, "lower_health_bar")

func lower_health_bar():
	life.rect_size.x -= 16
	

