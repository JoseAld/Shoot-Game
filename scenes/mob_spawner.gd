extends Node2D

@onready var main = get_node("/root/Main")

signal hit_p

var bichão_scene := preload("res://scenes/bichão.tscn")
var spawn_points := []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func _on_timer_timeout():
	#check how many enemies have already been created
	var inimigos = get_tree().get_nodes_in_group("inimigos")
	if inimigos.size() < get_parent().max_inimigos:
		#pick random spawn point
		var spawn = spawn_points[randi() % spawn_points.size()]
		#spawn enemy
		var bichão = bichão_scene.instantiate()
		bichão.position = spawn.position
		bichão.hit_player.connect(hit)
		main.add_child(bichão)
		bichão.add_to_group("inimigos")

func hit():
	hit_p.emit()
