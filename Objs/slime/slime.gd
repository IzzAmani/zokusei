extends Node2D

signal toggle_tablet(toggle: bool)

var mouse_entered_slime  := false
var player_entered_slime := false
var tablet_visible       := false
var player : Node = null

# Dict => Attr_Name : [type(bool, int, str), whatToChange ]
@export var attributes: Dictionary

func _ready():
    add_to_group("Objects")
    add_to_group("Slimes")
    
    for attr in attributes :
        if attr == "Collision" :
            $Hitbox/CollisionShape2D.disabled = !attributes[attr]
            
    attributes = attributes.duplicate(true)


func _on_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        player_entered_slime = true
        player = body
    
func _on_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        player_entered_slime = false
        tablet_visible = false
        emit_signal("toggle_tablet", false)


func _on_area_mouse_entered() -> void:
    mouse_entered_slime = true
    if player_entered_slime :
        Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        
func _on_area_mouse_exited() -> void:
    mouse_entered_slime = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func update_attr(key, value) :
    attributes[key] = value

func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") : 
        # toggle the visibility
        if mouse_entered_slime and player_entered_slime:
            tablet_visible = !tablet_visible
            emit_signal("toggle_tablet", tablet_visible)
            

func _process(delta) :
    if !player_entered_slime or !player :
        return
    
    elif position.distance_to(player.position) < 64 :
        return
        
    var angle
    if !attributes.Hostile :
        angle = randi() % 360
            
    else :
        var diff : Vector2 = player.position - position
        angle = atan2(diff.y, diff.x)
    
    position += Vector2(1, 0).rotated(angle)
        
    print(player.position.distance_to(position))
