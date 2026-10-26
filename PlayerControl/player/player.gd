extends KinematicBody2D

# Carregando o node de animações
onready var anim: AnimationPlayer = $Animation
onready var direction_pivot: Node2D = $DirectionPivot

# Definindo constantes
const GRAVITY: float = 300.0
const JUMP_FORCE: float  = -170.0
const SPEED: float = 110.0

var direction: int = 0

var velocity: Vector2 = Vector2(0, 0)

enum { 
	ATTACK, CROUCH, DEAD, FALL, HIT, IDLE, JUMP, 
	LANDING, RUN, SHIELD, SPELL_ATTACK, WALL_SLIDE 
	}

var StateMachine: int = IDLE 
# Called when the node enters the scene tree for the first time.
func _ready():
	# Garante que a animação inicial (IDLE) comece a rodar ao iniciar a cena
	change_state(IDLE)
	pass # Replace with function body.

func change_state(new_state: int) -> void:
    if StateMachine == new_state:
        return
        
    StateMachine = new_state
	# Gerencia qual animação toca ao entrar em cada estado
    match StateMachine:
        IDLE:
            anim.play("idle")
        RUN:
            anim.play("run")
        FALL:
            anim.play("fall")
        JUMP:
            anim.play("jump")
        LANDING:
            anim.play("landing")
            yield(anim, "animation_finished")
            change_state(IDLE)
#        RUN:
#            anim.play("run")
#        RUN:
#            anim.play("run")
#        RUN:
#            anim.play("run")
#        RUN:
#            anim.play("run")
#        RUN:
#            anim.play("run")


func _physics_process(delta):
	match StateMachine:
		ATTACK:
			
			pass
		CROUCH:
			pass
		DEAD:
			pass
		FALL:
			if is_on_floor():
				change_state(LANDING)
			pass
		HIT:
			pass
		IDLE:
			# Retorna -1 (esquerda), 0 (parado) ou 1 (direita)
			if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
				change_state(RUN)
			if Input.is_action_just_released("ui_select"):
				velocity.y = JUMP_FORCE
				change_state(JUMP)
		JUMP:
			direction = 0
#			if velocity.y > 0:
#				change_state(FALL)
		LANDING:
			velocity.x = 0
			anim.play("landing")
			yield(anim, "animation_finished")
			change_state(IDLE)
			pass
		RUN:
			if Input.is_action_pressed("ui_right"):
				direction_pivot.scale.x = 1
				direction = 1
			elif Input.is_action_pressed("ui_left"):
				direction_pivot.scale.x = -1
				direction = -1
			else:
				direction = 0
			if direction == 0: 
				change_state(IDLE)
			if Input.is_action_just_pressed("ui_select"):
				velocity.y = JUMP_FORCE
				change_state(JUMP)
			velocity.x = direction * SPEED
		SHIELD:
			pass
		WALL_SLIDE:
			pass
			
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	if velocity.y > 0:
		change_state(FALL)
#	print(velocity)
	
func apply_gravity(delta):
	velocity.y = velocity.y + GRAVITY * delta
