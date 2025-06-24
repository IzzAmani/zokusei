extends CharacterBody2D

@export var speed = 400
var scr_size;
var frames = 0


func _ready():
    scr_size = get_viewport_rect().size
    
func _physics_process(delta):
    velocity = Vector2.ZERO
    
    if Input.is_action_pressed("playermoveR"):
        velocity.x += 1
        
    if Input.is_action_pressed("playermoveL"):
        velocity.x -= 1
       
    if Input.is_action_pressed("playermoveD"):
        velocity.y += 1
       
    if Input.is_action_pressed("playermoveU"):
        velocity.y -= 1
        
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
       
    move_and_slide()



func _on_interact_range_body_entered(body: Node2D):
    print("body:", body)
