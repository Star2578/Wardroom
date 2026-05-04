extends CharacterBody3D

enum States {idle, roam, chase}

var state = States.idle
var speed = 3
var accel = 10
var gravity = 9.8
var target: Node3D = null
var roam_timer = 0.0
var roam_wait = 0.0  # randomized each time
var lose_sight_timer = 0.0

@export var lose_sight_delay: float = 3.0
@export var vision_angle: float = 45.0   # degrees, each side = 90° total cone
@export var vision_range: float = 10.0

@export var navAgent: NavigationAgent3D
@export var navRegion: NavigationRegion3D
@export var random_points: Node3D
@export var animationPlayer: AnimationPlayer
@onready var chasingAudio = $chasingAudio
@onready var look_at_player: LookAtModifier3D = %LookAtPlayer
@onready var attackingAudio = $attackingAudio
@onready var game_over_ui = $gameOverUI

func _ready():
	await get_tree().physics_frame 
	_pick_roam_target()

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity

	match state:
		States.idle:
			velocity = velocity.lerp(Vector3.ZERO, accel * delta)
			animationPlayer.play("crouch")
			look_at_player.active = false
			
			roam_timer += delta
			if roam_timer >= roam_wait:
				_pick_roam_target()

		States.roam:
			animationPlayer.play("crawl")
			look_at_player.active = false
			
			if navAgent.is_navigation_finished():
				_start_idle() # Switch to idle to wait
			else:
				var next_pos = navAgent.get_next_path_position()
				var dir = (next_pos - global_position).normalized()
				velocity = velocity.lerp(dir * speed, accel * delta)
				
				if dir.length() > 0.1:
					var look_dir = Vector3(dir.x, 0, dir.z)
					look_at(global_position + look_dir, Vector3.UP, true)

		States.chase:
			print("CHASE")
			var can_see = can_see_player(target)
			var on_nav = is_player_on_navmesh(target)
			look_at_player.active = true

			if not on_nav:
				# immediate stop — player escaped to safe room or outside
				_stop_chase()
			elif not can_see:
				print("cannot see")
				lose_sight_timer += delta
				if lose_sight_timer >= lose_sight_delay:
					_stop_chase()
			else:
				lose_sight_timer = 0.0  # reset timer whenever sight is regained

			look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
			navAgent.target_position = target.global_position
			var dir = (navAgent.get_next_path_position() - global_position).normalized()
			velocity = velocity.lerp(dir * speed, accel * delta)
			animationPlayer.play("crawl")

	move_and_slide()

func _start_idle():
	state = States.idle
	roam_timer = 0.0
	roam_wait = randf_range(1.0, 3.0)
	print("Ghost is resting...")

func _pick_roam_target():
	if random_points.get_child_count() == 0: return
	
	var random_idx = randi_range(0, random_points.get_child_count() - 1)
	var point = random_points.get_child(random_idx)
	
	navAgent.target_position = point.global_position
	state = States.roam
	print("Ghost moving to: ", point.name)

func can_see_player(player: Node3D):
	var to_player := player.global_position - global_position

	if to_player.length() > vision_range:
		print("too far: ", to_player.length())
		return false

	var forward := global_transform.basis.z
	var angle := rad_to_deg(forward.angle_to(to_player.normalized()))
	print("angle to player: ", angle, " | vision_angle: ", vision_angle)
	if angle > vision_angle:
		return false

	var query := PhysicsRayQueryParameters3D.create(
		global_position,
		player.global_position,
		1,
		[self]
	)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	print("ray hit: ", result.get("collider", "nothing"))

	return result and result.collider == player

func is_player_on_navmesh(player: Node3D):
	var closest = NavigationServer3D.map_get_closest_point(
		navRegion.get_navigation_map(),
		player.global_position
	)
	# if the nearest navmesh point is too far from player's actual position, they're off it
	return player.global_position.distance_to(closest) < 1.0

func _stop_chase():
	print("stop chase")
	lose_sight_timer = 0.0
	chasingAudio.stop()
	_pick_roam_target()  # go back to wandering

func _on_chase_area_body_entered(body: Node3D):
	if body.has_method("player"):
		target = body
		state = States.chase
		chasingAudio.play()

func _on_attack_area_body_entered(body: Node3D):
	if body.has_method("player"):
		target = body
		chasingAudio.stop()
		attackingAudio.play()
		game_over()

func game_over():
	game_over_ui.show()
	await get_tree().create_timer(2).timeout
	# get_tree().reload_current_scene()
	game_over_ui.hide()
	GameController.player.position = Vector3(43.159, 0, 26.064)
