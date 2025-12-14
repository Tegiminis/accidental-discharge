extends Node3D
class_name Spawner

@export var to_spawn: PackedScene

@onready var spawn_time: Timer = $SpawnTimer

func _ready() -> void:
	spawn_time.start()
	visible = false

func _on_spawn_timer_timeout() -> void:
	if to_spawn:
		var enemy : CharacterBody3D = to_spawn.instantiate()
		get_tree().get_root().add_child(enemy)
		enemy.position = position
