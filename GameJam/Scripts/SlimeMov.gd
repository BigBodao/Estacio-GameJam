extends KinematicBody2D

export var velocity = Vector2.ZERO
var move_speed = 600
export var gravity = 1200
var jump_force = -720
var is_grounded
onready var raycasts = $raycasts
#checagem do estado do personagem, em que forma ele está transformado
onready var is_slime = true
onready var is_cat = false
onready var is_mouse = false
onready var is_bird = false
var is_transforming = false


func _ready():
	pass

func _physics_process(delta: float) -> void:
	is_grounded = _check_is_grounded()
	velocity.y += gravity * delta
	if !is_bird:
		_get_input_grounded()
	else:
		_get_input_flying()
	_transform_slime()
	velocity = move_and_slide(velocity)
	set_animation()
	
func _get_input_grounded():
	velocity.x = 0
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)
	
	if move_direction != 0:
		$Sprite.scale.x = move_direction
	

func _get_input_flying():
	velocity = Vector2.ZERO
	var direction = Vector2()
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int (Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("jump"))
	
	velocity = lerp(velocity, direction * move_speed, 0.2)
	
	if direction.x != 0:
		$Sprite.scale.x = direction.x

func _input(event: InputEvent) -> void: #botão para pular que so funciona com gato
	if event.is_action_pressed('jump') && is_grounded && is_cat:
		velocity.y = jump_force / 1.5

func _check_is_grounded(): #checa se o personagem tem colisão no chão
	for raycast in raycasts.get_children():
		if raycast.is_colliding() && is_cat:
			#$AnimatedSprite.animation = 'cat_idle'
			return true
	#$AnimatedSprite.play('cat_jump')
	return false

func set_animation():
	var anim
	if is_cat: #criando animações de gato
		anim = 'cat_idle'
		if !is_grounded:
			anim = 'cat_jump'
		elif velocity.x != 0:
			anim = 'cat_walk'
	
	elif is_slime: #criando animções slime
		anim = 'slime_idle'
		if velocity.x != 0:
			anim = 'slime_walk'
			
	elif is_bird:
		anim = 'bird_fly'
		
	elif is_mouse:
		anim = 'mouse_idle'
		if velocity.x != 0:
			anim = 'mouse_walk'
			
	if $anim.assigned_animation != anim && !is_transforming:
		$anim.play(anim)
	
func _transform_slime():
	if Input.is_action_pressed('turn_slime') && is_slime == false:
		colider_activation()
		$colisor_slime.disabled = false
		if is_cat:
			$anim.play_backwards('turn_cat')
		elif is_bird:
			$anim.play_backwards('turn_bird')
		elif is_mouse:
			$anim.play_backwards('turn_mouse')
		is_transforming = true
		print('virou slime')
		is_cat = false
		is_bird = false
		is_slime = true
		is_mouse = false

	if Input.is_action_pressed('turn_cat') && is_cat == false:
		colider_activation()
		$colisor_cat.disabled = false
		$anim.play('turn_cat')
		is_transforming = true
		print('virou gato')
		is_cat = true
		is_bird = false
		is_slime = false
		is_mouse = false
		move_speed = 1200

	if Input.is_action_pressed("turn_mouse") && is_mouse == false:
		colider_activation()
		$colisor_rat.disabled = false
		$anim.play('turn_mouse')
		is_transforming = true
		print('virou rato')
		is_cat = false
		is_bird = false
		is_slime = false
		is_mouse = true

	if Input.is_action_pressed("turn_bird") && is_bird == false:
		colider_activation()
		$colisor_bird.disabled = false
		$anim.play('turn_bird')
		is_transforming = true
		print('virou passaro')
		is_cat = false
		is_bird = true
		is_slime = false
		is_mouse = false

func colider_activation():
	$colisor_bird.disabled = true
	$colisor_cat.disabled = true
	$colisor_rat.disabled = true
	$colisor_slime.disabled = true




func _on_anim_animation_finished(anim_name):
	if anim_name == 'turn_slime' or 'turn_cat' or 'turn_bird' or 'turn_rat':
		is_transforming = false
