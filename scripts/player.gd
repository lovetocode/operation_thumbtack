class_name player extends CharacterBody2D

@export var speed = 300
@onready var rate_of_fire = 0.25

signal bullet_shot(bullet_scene, location)

@onready var left_inside_muzzle = $LeftInsideMuzzle
@onready var left_middle_muzzle = $LeftMiddleMuzzle
@onready var left_outside_muzzle = $LeftOutsideMuzzle
@onready var right_inside_muzzle = $RightInsideMuzzle
@onready var right_middle_muzzle = $RightMiddleMuzzle
@onready var right_outside_muzzle = $RightOutsideMuzzle

var shoot_cd = false
 
var bullet_scene = preload("res://scenes/bullet.tscn")

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	velocity = direction * speed
	move_and_slide()

func shoot():
	bullet_shot.emit(bullet_scene, left_inside_muzzle.global_position)
	bullet_shot.emit(bullet_scene, right_inside_muzzle.global_position)
	
	
func die():
	queue_free()
