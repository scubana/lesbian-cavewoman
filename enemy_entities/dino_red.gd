class_name dino_red
extends CharacterBody2D

@onready var wall_ray_cast_left = $Wall_Checks/Wall_RayCast_Left as RayCast2D
@onready var wall_ray_cast_right = $Wall_Checks/Wall_RayCast_Right as RayCast2D
@onready var floor_ray_cast_left = $Floor_Chekcs/Floor_RayCast_Left as RayCast2D
@onready var floor_ray_cast_right = $Floor_Chekcs/Floor_RayCast_Right as RayCast2D
@onready var player_track_raycast = $Player_Tracker_Pivot/Player_Track_Raycast as RayCast2D
@onready var player_tracker_pivot = $Player_Tracker_Pivot as Node2D

@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var chase_timer = $Chase_Timer as Timer

@export var wander_speed : float = 40.0
@export var chase_speed : float = 80.0

var current_speed : float = 0.0
var player_found : bool = false
var player : PlayerEntity = null

enum States{
	Wander,
	Chase
}

var current_state = States.Wander

func _ready():
	player = get_tree().get_first_node_in_group("player")
	chase_timer.timeout.connect(on_timer_timeout)
	
	
func _physics_process(_delta):
	handle_vision()
	track_player()
	handle_movement()
	move_and_slide()
	handle_flip()
	
	
func handle_movement() -> void:
	var direction = global_position - player.global_position
	
	if current_state == States.Wander:
		if floor_ray_cast_right.is_colliding() != true:
			current_speed = -wander_speed
		if floor_ray_cast_left.is_colliding() != true:
			current_speed = wander_speed
		if wall_ray_cast_right.is_colliding():
			print("ouch")
			current_speed = -wander_speed
		if wall_ray_cast_left.is_colliding():
			current_speed = wander_speed
		
	if current_state == States.Chase:
		if player_found == true:
			if direction.x < 0:
				current_speed = chase_speed
			else:
				current_speed = -chase_speed
			
	
	
	
	velocity.x = current_speed




func track_player():
	if player == null:
		return
	
	# center point number
	var direction_to_player : Vector2 = Vector2(player.position.x, player.position.y - 16) - player_track_raycast.position
	
	player_tracker_pivot.look_at(direction_to_player)

	
func handle_vision():
	if player_track_raycast.is_colliding():
		var collision_result = player_track_raycast.get_collider()
		
		if collision_result != player:
			return
		else:
			current_state = States.Chase
			chase_timer.start(1)
			player_found = true
	
	else:
		player_found = false

func handle_flip():
	var velocity_sign = sign(velocity.x)
	
	if velocity_sign < 0:
		sprite_2d.flip_h = false
	else:
		sprite_2d.flip_h = true
	


func on_timer_timeout() -> void:
	if player_found == false:
		current_state = States.Wander
