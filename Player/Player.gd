extends Node2D

const DEGREE_PER_SECOND = 90.0
const TIME_PER_HOOK = 1.0
const REEL_IN_SPEED = 1.0

onready var hook = $Hook
onready var hook_spr = $Hook/Hook
onready var mine_ray = $Hook/MineRay
onready var right = true
onready var action = false
onready var timer = 0
onready var start_pos = hook.global_position
onready var collision_pos = Vector2(0,0)
onready var collision_obj
onready var speed = REEL_IN_SPEED

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _process(delta):
	if (action == false):
		_hook(delta)
		if Input.is_action_just_pressed("ui_accept"):
			grab()
	if (action):
		_move_hook(collision_pos, delta)

func grab():
	if	mine_ray.is_colliding():
		action = true
		collision_pos = mine_ray.get_collision_point()
		if (mine_ray.get_collider().is_in_group("Moveable")):
			collision_obj = mine_ray.get_collider()
			speed *= collision_obj.scale.x

func _move_hook(point, delta):
	timer += delta
	if (timer < TIME_PER_HOOK):
		hook.global_position = start_pos + (timer / TIME_PER_HOOK * (point - start_pos))
	if (timer >= TIME_PER_HOOK && timer < TIME_PER_HOOK + speed):
		hook.global_position = (point) - ((timer - TIME_PER_HOOK) / speed * (point - start_pos))
		if (is_instance_valid(collision_obj)):
			collision_obj.position = hook_spr.global_position
	if (timer >= TIME_PER_HOOK + speed):
		action = false
		timer = 0
		collision_pos = Vector2(0,0)
		speed = TIME_PER_HOOK
	
func _hook(delta):
	var rotation = hook.rotation_degrees
	var direction = 1;
	if(right == true):
		direction = -DEGREE_PER_SECOND * delta
	if(right == false):
		direction = DEGREE_PER_SECOND * delta
	if(rotation >= 60):
		right = true
	if(rotation <= -60):
		right = false
	hook.rotation_degrees += direction
	pass
