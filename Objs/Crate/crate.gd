extends Node2D

signal toggle_tablet(toggle: bool)

var mouse_entered_crate  := false
var player_entered_crate := false
var tablet_visible       := false

# Dict => Attr_Name : [type(bool, int, str), whatToChange ]
@export var attributes: Dictionary

func _ready():
    add_to_group("Objects")
    add_to_group("Crates")
    
    for attr in attributes :
        if attr == "Collision" :
            $Hitbox/CollisionShape2D.disabled = !attributes[attr]
            
    attributes = attributes.duplicate(true)


func _on_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        player_entered_crate = true
    
func _on_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        player_entered_crate = false
        tablet_visible = false
        emit_signal("toggle_tablet", false)


func _on_area_mouse_entered() -> void:
    mouse_entered_crate = true
    if player_entered_crate :
        Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        
func _on_area_mouse_exited() -> void:
    mouse_entered_crate = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func update_attr(key, value) :
    attributes[key] = value

func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") : 
        # toggle the visibility
        if mouse_entered_crate and player_entered_crate:
            tablet_visible = !tablet_visible
            emit_signal("toggle_tablet", tablet_visible)
            
    elif evt.is_action_pressed("rightClick") and attributes["Flammable"] :
        if mouse_entered_crate and player_entered_crate:
            queue_free()
