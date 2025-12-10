extends Area3D
class_name Discharge

@export var debug_persist : bool = true
var damage = 0

func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	if not debug_persist:
		queue_free()
	if bodies:
		var target = null
		var last_dist = null
		for body in bodies:
			var dist = global_position.distance_to(body.global_position)
			if last_dist == null or last_dist > dist: 
				last_dist = dist
				target = body
		var hp : ComponentHealth = target.get("health")
		if hp:
			var injury = hp.injure(damage)
			print(injury)
		queue_free()
