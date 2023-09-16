extends CharacterBody2D

@export var speed = 300


signal bullet_shot(bullet_scene, location)

@onready var left_muzzle = $LeftMuzzle
@onready var right_muzzle = $RightMuzzle

var shoot_cd = false
 
var bullet_scene = preload("res://scenes/bullet.tscn")

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(0.25).timeout
			shoot_cd = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	velocity = direction * speed
	move_and_slide()

func shoot():
	bullet_shot.emit(bullet_scene, left_muzzle.global_position)
	bullet_shot.emit(bullet_scene, right_muzzle.global_position)
