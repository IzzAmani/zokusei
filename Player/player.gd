extends CharacterBody2D

@export var speed = 400
@export var direction: Vector2

var scr_size;
var frames = 0
var torch_rot = 0

@onready var Torch := $Torch
@onready var sprite = $Sprite2D

func _ready():
    scr_size = get_viewport_rect().size
    
    
    
func _physics_process(delta):
    velocity = Vector2.ZERO
    
    if Input.is_action_pressed("playermoveR"):
        velocity += Vector2(1, 0)
        direction = Vector2(1, 0)
        torch_rot = PI/2
        sprite.play("right")
        
    if Input.is_action_pressed("playermoveL"):
        velocity += Vector2(-1, 0)
        direction = Vector2(-1, 0)
        torch_rot = -PI/2
        sprite.play("left")
       
    if Input.is_action_pressed("playermoveD"):
        velocity += Vector2(0, 1)
        direction = Vector2(0, 1)
        torch_rot = PI
        sprite.play("down")
       
    if Input.is_action_pressed("playermoveU"):
        velocity += Vector2(0, -1)
        direction = Vector2(0, -1)
        torch_rot = 0
        sprite.play("up")
            
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
    else:
        sprite.frame = 1
       
    move_and_slide()
    
    Torch.modulate.a = 0
    if Input.is_action_pressed("rightClick") :
        Torch.modulate.a = 1
        Torch.position = Vector2(0, -64).rotated(torch_rot)
        Torch.rotation = torch_rot

    # detect every collision
    for collision in get_slide_collision_count() :
        var collided_node = get_slide_collision(collision).get_collider().get_parent()
        
        if collided_node.is_in_group("Vines") :
            if collided_node.attributes["Prickly"] :
               get_tree().root.get_node("Main/UI/HurtScr/ColorRect/AnimationPlayer").play("FadeOut") 
