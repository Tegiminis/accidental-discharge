extends RigidBody3D
class_name Weapon

@export var on_hit : PackedScene
@export var damage : int = 5

@onready var weapon_mesh : MeshInstance3D = $pistol_mesh
#@onready var world_collider : CollisionShape3D = $CollisionShape3D
@onready var world_colliders : Array[CollisionShape3D] = [$WorldCollision1, $WorldCollision2]
@onready var pickup_collider : CollisionShape3D = $PickupArea/CollisionShape3D
@onready var colliders : Array[CollisionShape3D] = [$WorldCollision1, $WorldCollision2, $PickupArea/CollisionShape3D]

var can_discharge : bool = true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if can_discharge:
		var collision = move_and_collide(linear_velocity*delta)
		if collision:
			pickup_collider.disabled = false
			# collision values
			var norm = collision.get_normal()
			var pos = collision.get_position()
			# discharge creation
			var discharge : Area3D = on_hit.instantiate()
			get_tree().get_root().add_child(discharge)
			discharge.position = pos
			var global_norm = discharge.to_global(norm)
			discharge.look_at(global_norm)
			discharge.damage = damage
			can_discharge = false

func _on_pickup_area_body_entered(body: Node3D) -> void:
	freeze = true
	linear_velocity = Vector3.ZERO
	var _body : Player = body
	#self.reparent(_body.held_weapon)
	global_position = _body.held_weapon.global_position
	global_rotation = _body.held_weapon.global_rotation
	can_discharge = true
	call_deferred("reparent", _body.held_weapon)
	disable_colliders(colliders)

func disable_colliders(nodes:Array):
	for collider in nodes:
		collider.disabled = true
func enable_colliders(nodes:Array):
	for collider in nodes:
		collider.disabled = false
