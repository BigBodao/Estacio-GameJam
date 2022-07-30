extends KinematicBody2D

export var velocity = Vector2.ZERO
var move_speed = 600
export var gravity = 1200
var jump_force = -720
var is_grounded
var is_wall
onready var raycasts = $raycasts
onready var raycastsWall1 = $raycastsWL
onready var raycastsWall2 = $raycastsWR
#checagem do estado do personagem, em que forma ele está transformado
onready var is_slime = true
onready var is_cat = false
onready var is_mouse = false
onready var is_bird = false
onready var is_transforming


func _ready():
	pass

func _physics_process(delta: float) -> void:
	is_grounded = _check_is_grounded()
	is_wall = _check_is_wall()
	velocity.y += gravity * delta
	if !is_bird:
		_get_input()
	else:
		_get_input_flying()
	_transform_slime()
	velocity = move_and_slide(velocity)
	set_animation()
	
func _get_input():
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
	#botão para voar que so funciona com passaro
	if event.is_action_pressed('jump') && is_bird:
		velocity.y = jump_force / 1.5

func _check_is_grounded(): #checa se o personagem tem colisão no chão
	for raycast in raycasts.get_children():
		if raycast.is_colliding() && is_cat:
			#$AnimatedSprite.animation = 'cat_idle'
			return true
	#$AnimatedSprite.play('cat_jump')
	return false

func _check_is_wall():
	for raycast in raycastsWall1.get_children():
		for raycast2 in raycastsWall2.get_children():
			if raycast.is_colliding() && is_cat:
				print('bateu na parede')
				return true
	return false
	
func set_animation():
	var anim
	if is_cat: #criando animações de gato
		anim = 'cat_idle'
		if !is_grounded:
			anim = 'cat_jump'
		elif velocity.x != 0:
			anim = 'cat_walk'
		else:
			anim = 'cat_idle'
	
	elif is_slime: #criando animções slime
		anim = 'slime_idle'
		if velocity.x != 0:
			anim = 'slime_walk'
		else:
			anim = 'slime_idle'
			
	elif is_bird:
		anim = 'bird_fly'
		
	elif is_mouse:
		anim = 'mouse_idle'
		if velocity.x != 0:
			anim = 'mouse_walk'
		else:
			anim = 'mouse_idle'
			
	if $anim.assigned_animation != anim && !is_transforming:
		$anim.play(anim)
	
func _transform_slime():
	var anim
	
	if Input.is_action_pressed('turn_cat') && is_cat == false:
		anim = 'turn_cat'
		colider_activation()
		colider_wall_enable()
		$colisor_cat.disabled = false
		
		$anim.play(anim)
		is_transforming = true
		$transform_timer.start()
		print('virou gato')
		is_cat = true
		is_bird = false
		is_slime = false
		is_mouse = false
		move_speed = 1200
		
	if Input.is_action_pressed('turn_slime') && is_slime == false:
		colider_activation()
		colider_wall_desenable()
		
		$colisor_slime.disabled = false
		
		if is_cat:
			anim = 'turn_cat'
			$anim.play_backwards(anim)
		elif is_bird:
			anim = 'turn_bird'
			$anim.play_backwards(anim)
		elif is_mouse:
			anim = 'turn_mouse'
			$anim.play_backwards(anim)
		is_transforming = true
		$transform_timer.start()
		
		print('virou slime')
		is_cat = false
		is_bird = false
		is_slime = true
		is_mouse = false
		
	if Input.is_action_pressed("turn_mouse") && is_mouse == false:
		colider_activation()
		colider_wall_desenable()
		
		anim = 'turn_mouse'
		$colisor_rat.disabled = false
		
		$anim.play(anim)
		is_transforming = true
		$transform_timer.start()
		print('virou rato')
		
		is_cat = false
		is_bird = false
		is_slime = false
		is_mouse = true
		
	if Input.is_action_pressed("turn_bird") && is_bird == false:
		colider_activation()
		colider_wall_desenable()
		
		anim = 'turn_bird'
		$colisor_bird.disabled = false
		
		$anim.play(anim)
		is_transforming = true
		$transform_timer.start()
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
	
func colider_wall_enable():
	$raycastsWL/RayCastL1.enabled = true
	$raycastsWR/RayCastR1.enabled = true
	

func colider_wall_desenable():
	$raycastsWL/RayCastL1.enabled = false
	$raycastsWR/RayCastR1.enabled = false

func _on_transform_timer_timeout():
	is_transforming = false
