extends KinematicBody2D

export var speed = 200.0
const SPEED = 180

func _ready():
	$AnimatedSprite.play('idle')
	
func _physics_process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	if direction.length()	> 0:
		direction = direction.normalized()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.play('idle')
	
	position += direction*speed*delta
	
	if direction.x != 0:
		$AnimatedSprite.animation = 'walk'
		$AnimatedSprite.flip_h = direction.x < 0
	else:
		$AnimatedSprite.animation = 'idle'

