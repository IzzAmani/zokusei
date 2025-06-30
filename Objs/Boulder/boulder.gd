extends Node2D

signal toggle_tablet(toggle: bool)

var mouse_entered_boulder  := false
var player_entered_boulder := false
var tablet_visible      := false

# Dict => Attr_Name : [type(bool, int, str), whatToChange ]
@export var attributes: Dictionary

func _ready():
    add_to_group("Objects")
    
    for attr in attributes :
        if attr == "Collision" :
            $Hitbox/CollisionShape2D.disabled = !attributes[attr]

func _on_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        player_entered_boulder = true
    
func _on_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        player_entered_boulder = false
        tablet_visible = false
        emit_signal("toggle_tablet", tablet_visible)



func update_attr(key, value) :
    attributes[key] = value


func _on_area_mouse_entered() -> void:
    mouse_entered_boulder = true
    if player_entered_boulder :
        Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        
func _on_area_mouse_exited() -> void:
    mouse_entered_boulder = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") : 
        # toggle the visibility
        if mouse_entered_boulder and player_entered_boulder:
            tablet_visible = !tablet_visible
            emit_signal("toggle_tablet", tablet_visible)
