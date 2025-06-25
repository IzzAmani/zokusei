extends CharacterBody2D

@export var speed = 400
@export var direction: Vector2

var scr_size;
var frames = 0


func _ready():
    scr_size = get_viewport_rect().size
    
    
    
func _physics_process(delta):
    velocity = Vector2.ZERO
    
    if Input.is_action_pressed("playermoveR"):
        velocity += Vector2(1, 0)
        direction = Vector2(1, 0)
        
    if Input.is_action_pressed("playermoveL"):
        velocity += Vector2(-1, 0)
        direction = Vector2(-1, 0)
       
    if Input.is_action_pressed("playermoveD"):
        velocity += Vector2(0, 1)
        direction = Vector2(0, 1)
       
    if Input.is_action_pressed("playermoveU"):
        velocity += Vector2(0, -1)
        direction = Vector2(0, -1)
            
    
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
       
    move_and_slide()



func _on_interact_range_body_entered(body: Node2D):
    print("body:", body)
