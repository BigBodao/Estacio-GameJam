extends KinematicBody2D

#constantes
const Gravity := 200.00
const WalkS := 200

#vetor Velocidade
var vel = Vector2()

func _physics_process(delta):
	#A slime é afetada pela gravidade
	vel.y += delta * Gravity
	
	#Olhar inputs
	if Input.is_action_pressed("ui_left"):
		vel.x = -WalkS
	elif Input.is_action_pressed("ui_right"):
		vel.x = WalkS
	else:
		vel.x = 0
	
	#Botar o movimento em prática
	move_and_slide(vel, Vector2.UP)
