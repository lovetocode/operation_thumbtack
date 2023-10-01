extends Node2D

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var bullet_container = $BulletContainer
@onready var enemy_container = $EnemyContainer
@onready var timer = $EnemySpawnTimer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen
@onready var pb = $ParallaxBackground
@onready var bullet_sound = $SFX/Bullet_sound
@onready var explode_sound = $SFX/Explode_sound
@onready var hit_sound = $SFX/Hit_sound
@onready var game_over_sound = $SFX/Game_over_sound
@onready var negative_sound = $SFX/Negative_sound
@onready var wolfSynth_sound = $SFX/WolfSynth_sound

@export var enemy_scenes: Array[PackedScene] = []

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score = 0
var scroll_speed = 100

func _ready():
	wolfSynth_sound.play()
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
	score = 0
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.bullet_shot.connect(_on_bullet_shot)
	player.killed.connect(_on_player_killed)
	
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

		
	if timer.wait_time > 0.5:
		timer.wait_time -= delta*0.05
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
		
	pb.scroll_offset.y += scroll_speed*delta
	if pb.scroll_base_offset.y >= 800:
		pb.scroll_offset = 0
	
func _on_bullet_shot(bullet_scene, location):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = location
	bullet_container.add_child(bullet)
	bullet_sound.play()
	

func _on_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50,500), -50)
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_one_enemy_hit)
	enemy_container.add_child(e)
	
func _on_enemy_killed(points):
	hit_sound.play()
	score += points
	if score > high_score:
		high_score = score
		
	
func _on_player_killed():
	explode_sound.play()
	await get_tree().create_timer(1.5).timeout
	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()
	get_tree().paused = false
	gos.visible = true
	game_over_sound.play()
	
func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
	
func _one_enemy_hit():
	hit_sound.play()
