extends RigidBody3D
class_name Weapon

@export var on_hit : PackedScene

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(linear_velocity*delta)
	if collision:
		var norm = collision.get_normal()
		var pos = collision.get_position()
	
		var discharge = on_hit.instantiate()
		get_tree().get_root().add_child(discharge)
		discharge.position = pos
		discharge.look_at(to_global(norm))
		queue_free()
