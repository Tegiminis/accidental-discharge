extends RigidBody3D
class_name Weapon

@export var on_hit : PackedScene

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(linear_velocity*delta)
	if collision:
		print(collision.get_collider())
		var norm = collision.get_normal()
		var pos = collision.get_position()
	
		var new_impact = on_hit.instantiate()
		get_tree().get_root().add_child(new_impact)
		new_impact.position = pos
		new_impact.rotation = norm
		queue_free()
