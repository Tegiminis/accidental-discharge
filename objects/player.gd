extends CharacterBody3D
class_name Player

@export var health : Resource
@export var weapon : PackedScene

@onready var camera : Node3D = $cam_pivot
@onready var held_weapon : Node3D = $cam_pivot/held_weapon
var smooth_animation_input : Vector2 

var mouse_delta : Vector2 = Vector2()
var lookangle_min : float = -90.0
var lookangle_max : float = 90.0
var look_sensitivity : float = 10.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func _ready():
	health._ready()

func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0

	var input_dir = Input.get_vector("left", "right", "forward", "back")

	var forward = global_transform.basis.z
	var right = camera.global_transform.basis.x
	
	var relativeDir = (forward * input_dir.y + right * input_dir.x)

	# set the velocity
	velocity.x = relativeDir.x * SPEED
	velocity.z = relativeDir.z * SPEED

	# apply gravity
	velocity.y -= gravity * delta / 2

	# move the player
	move_and_slide()
	
	# apply gravity again (midpoint method)
	velocity.y -= gravity * delta / 2

	# jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("throw"):
		var look_vector = -camera.get_global_transform().basis.z 
		if held_weapon.get_children():
			var new_wep : Weapon = held_weapon.get_child(0)
			new_wep.reparent(get_tree().get_root())
			new_wep.global_position = camera.global_position
			new_wep.global_rotation = Vector3(randfn(0, 2),randfn(0, 2),randfn(0, 2))
			new_wep.freeze = false
			new_wep.apply_impulse(look_vector * 10)
			new_wep.apply_torque(Vector3(randfn(2, 2)*5,randfn(2, 2)*5,randfn(2, 2)*5))
	
	# camera looking
	if mouse_delta:
		process_camera(delta)

#demonstrating

func process_camera(delta):
	camera.rotation_degrees.x -= mouse_delta.y * look_sensitivity * delta

	# Should clamp this value, but this code isn't working right ATM
	#camera.rotation_degrees.x = clamp(rotation_degrees.x, lookangle_min, lookangle_max)

	# rotate the player along their y-axis
	rotation_degrees.y -= mouse_delta.x * look_sensitivity * delta
	
	mouse_delta = Vector2()
