extends CharacterBody3D

enum States {attack, idle, chase, die}

var state = States.idle
var speed = 3
var accel = 10
var gravity = 9.8
var target = null

@export var navAgent: NavigationAgent3D
@export var animationPlayer: AnimationPlayer
@onready var chasingAudio = $chasingAudio
@onready var attackingAudio = $attackingAudio
@onready var game_over_ui = $gameOverUI

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity
		
	if state == States.idle:
		velocity = Vector3.ZERO
		animationPlayer.play("crouch")
	elif state == States.chase:
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
		navAgent.target_position = target.global_position
		
		var direction = navAgent.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		animationPlayer.play("crawl")
	elif state == States.attack:
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
		animationPlayer.play("crawl")
		velocity = Vector3.ZERO
	elif state == States.die:
		animationPlayer.play("crawl")
		velocity = Vector3.ZERO
		
	move_and_slide()

func game_over():
	game_over_ui.show()
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene()

func _on_chase_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		target = body
		state = States.chase
		chasingAudio.play()

func _on_chase_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		target = null
		state = States.idle
		chasingAudio.stop()

func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.has_method("player"):
		target = body
		state = States.attack
		chasingAudio.stop()
		attackingAudio.play()
		game_over()

func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.has_method("player"):
		state = States.chase
		attackingAudio.stop()
		chasingAudio.play()
