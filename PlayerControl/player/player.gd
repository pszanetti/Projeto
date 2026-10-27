extends KinematicBody2D

onready var anim: AnimationPlayer = $Animation
onready var direction_pivot: Node2D = $DirectionPivot
onready var wall_ray: RayCast2D = $DirectionPivot/WallRayCast

const GRAVITY: float = 300.0
const JUMP_FORCE: float = -170.0
const SPEED: float = 110.0
const WALL_GRAVITY: float = 80.0
const WALL_JUMP: float = -170.0

var direction: int = 0
var velocity: Vector2 = Vector2(0, 0)

enum { 
	ATTACK, CROUCH, DEAD, FALL, HIT, IDLE, JUMP, 
	LANDING, RUN, SHIELD, SPELL_ATTACK, WALL_SLIDE 
}

var StateMachine: int = IDLE 

func _ready():
	change_state(IDLE)

func change_state(new_state: int) -> void:
	if StateMachine == new_state:
		return    
	StateMachine = new_state
	match StateMachine:
		IDLE:
			anim.play("idle")
		RUN:
			anim.play("run")
		FALL:
			anim.play("fall")
		JUMP:
			velocity.y = JUMP_FORCE
			anim.play("jump")
		LANDING:
			anim.play("landing")
		ATTACK:   
			anim.play("attack")
		CROUCH:
			anim.play("crouch")
		SHIELD:
			anim.play("shield")
		WALL_SLIDE:
			anim.play("wall_slide")

func _physics_process(delta):
	# 1. Checagem prioritária de inputs globais enquanto está no chão
	if (StateMachine == IDLE or StateMachine == RUN) and is_on_floor():
		if Input.is_action_just_pressed("ui_select"):
			change_state(JUMP)
			return
		if Input.is_action_just_pressed("attack"):
			change_state(ATTACK)
			return
		if Input.is_action_pressed("shield"):
			change_state(SHIELD)
			return

	# 2. Comportamento específico de cada estado
	match StateMachine:
		ATTACK:
			velocity.x = 0
			
		CROUCH:
			velocity.x = 0
			if Input.is_action_just_released("ui_down"):
				change_state(IDLE)
				
		DEAD:
			pass
			
		FALL:
			apply_gravity(delta)
			horizontal_move()
			if is_on_floor():
				change_state(LANDING)
			elif wall_ray.is_colliding() and not is_on_floor():
				change_state(WALL_SLIDE)
				
		HIT:
			pass
			
		SHIELD:
			velocity.x = 0
			if not Input.is_action_pressed("shield"):
				change_state(IDLE)
				
		IDLE:
			velocity.x = 0
			apply_gravity(delta)
			if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
				change_state(RUN)
			
		JUMP:
			apply_gravity(delta)
			horizontal_move()
			# Se a velocidade vertical virar positiva, começa a cair
			if velocity.y > 0:
				change_state(FALL)
				
		LANDING:
			velocity.x = 0
			apply_gravity(delta)
			if not anim.is_playing():
				if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
					change_state(RUN)
				else:
					change_state(IDLE)
			
		RUN:
			horizontal_move()
			apply_gravity(delta)
			if direction == 0: 
				change_state(IDLE)
			
		WALL_SLIDE:
			velocity.x = 0
			velocity.y += WALL_GRAVITY * delta
			if Input.is_action_just_pressed("ui_select"):
				velocity.y = WALL_JUMP
				change_state(JUMP)
			if not wall_ray.is_colliding():
				change_state(FALL)
			elif is_on_floor():
				change_state(IDLE)

	# Movimento final processado uma única vez por frame
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity(delta):
	velocity.y = velocity.y + GRAVITY * delta

func horizontal_move() -> void:
	if Input.is_action_pressed("ui_right"):
		direction_pivot.scale.x = 1
		direction = 1
	elif Input.is_action_pressed("ui_left"):
		direction_pivot.scale.x = -1
		direction = -1
	else:
		direction = 0
	velocity.x = direction * SPEED
