extends Control

onready var ammo = $Ammo
onready var player = get_node("../YSort/Player")

func _ready():
	ammo.rect_size.y = 16 * player.ammo
	player.connect("fired", self, "lower_ammo_bar")
	player.connect("reload", self, "reset_ammo_bar")
	
func lower_ammo_bar():
	ammo.rect_size.y -= 16
	
func reset_ammo_bar():
	ammo.rect_size.y = 16 * player.ammo
