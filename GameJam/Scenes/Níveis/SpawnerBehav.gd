extends Node2D

export (PackedScene) var player_prefab

onready var start_pos := position

func _ready():
	_spawn(start_pos)

func _spawn(position):
	print("Deletando anteriores...")
	for node in $"..".get_children():
		if  node.is_in_group('player'):
			node.queue_free()
	
	print("Spawnando...")
	var player = player_prefab.instance()
	print("Ajustando Posição...")
	player.position = start_pos
	get_parent().call_deferred("add_child",player)


func _on_Exit_body_entered(body):
	get_tree().change_scene("res://Scenes/Níveis/Nível_1.tscn")
