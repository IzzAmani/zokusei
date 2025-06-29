extends CharacterBody2D

@export var speed = 400
@export var direction: Vector2
@export var player_rot: float = 0

var scr_size;
var frames = 0
var detected := {"body": null, "direction": null}

@onready var Torch := $Torch
@onready var sprite = $Sprite2D

func _ready():
    scr_size = get_viewport_rect().size
    
    
    
func _physics_process(delta):
    velocity = Vector2.ZERO
    
    if Input.is_action_pressed("playermoveR"):
        velocity += Vector2(1, 0)
        direction = Vector2(1, 0)
        player_rot = 0
        
    if Input.is_action_pressed("playermoveL"):
        velocity += Vector2(-1, 0)
        direction = Vector2(-1, 0)
        player_rot = PI
       
    if Input.is_action_pressed("playermoveD"):
        velocity += Vector2(0, 1)
        direction = Vector2(0, 1)
        player_rot = PI/2
       
    if Input.is_action_pressed("playermoveU"):
        velocity += Vector2(0, -1)
        direction = Vector2(0, -1)
        player_rot = -PI/2

        
    if direction.x == 1 :
        sprite.play("right")

    elif direction.x == -1 :
        sprite.play("left")

    elif direction.y == -1:
        sprite.play("up")
    
    elif direction.y == 1:
        sprite.play("down")



    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
    else:
        sprite.frame = 1
       
    move_and_slide()
    
    Torch.modulate.a = 0
    if Input.is_action_pressed("rightClick") :
        Torch.modulate.a = 1
        Torch.position = Vector2(0, -64).rotated(player_rot + PI/2)
        Torch.rotation = player_rot + PI/2

    # detect every collision
    for collision in get_slide_collision_count() :
        var collided_node = get_slide_collision(collision).get_collider().get_parent()
        
        if collided_node.is_in_group("Vines") and collided_node.attributes["Prickly"] :
            get_tree().root.get_node("Main/UI/HurtScr/ColorRect/AnimationPlayer").play("FadeOut")
            
    # For pushing crates idk
    if detected.body :
        if detected.body.is_in_group("Crates") :
            var friction = 169
            var offset_factor = friction * 0.75 + 18.75
            
            print(friction, " ", offset_factor)
            
            # offset the sprite so it looks like its pushing lolol
            detected.body.get_node("Sprite2D").position = Vector2(-1 * speed / offset_factor ,0).rotated(detected.direction)
            detected.body.position += Vector2(1 * speed / friction, 0).rotated(detected.direction) # +100 , + 75



func _on_right_body_entered(body: Node2D) -> void:
    body = body.get_parent()
    detected = {
        "body": body,
        "direction": 0
    }

func _on_right_body_exited(body: Node2D) -> void:
    body = body.get_parent()
    
    if body.is_in_group("Crates"): 
        body.get_node("Sprite2D").position = Vector2.ZERO
    detected.body = null



func _on_left_body_entered(body: Node2D) -> void:
    body = body.get_parent()
    detected = {
        "body": body,
        "direction": PI
    }

func _on_left_body_exited(body: Node2D) -> void:
    body = body.get_parent()
    
    if body.is_in_group("Crates"): 
        body.get_node("Sprite2D").position = Vector2.ZERO
    detected.body = null



func _on_up_body_entered(body: Node2D) -> void:
    body = body.get_parent()
    detected = {
        "body": body,
        "direction": -PI/2
    }

func _on_up_body_exited(body: Node2D) -> void:
    body = body.get_parent()
    
    if body.is_in_group("Crates"): 
        body.get_node("Sprite2D").position = Vector2.ZERO
    detected.body = null



func _on_down_body_entered(body: Node2D) -> void:
    body = body.get_parent()
    detected = {
        "body": body,
        "direction": PI/2
    }

func _on_down_body_exited(body: Node2D) -> void:
    body = body.get_parent()
    
    if body.is_in_group("Crates"): 
        body.get_node("Sprite2D").position = Vector2.ZERO
    detected.body = null
