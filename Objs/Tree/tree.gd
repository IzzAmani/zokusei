extends Node2D

signal toggle_tablet(toggle: bool)

var mouse_entered_tree  := false
var player_entered_tree := false
var tablet_visible      := false

# Dict => Attr_Name : [type(bool, int, str), whatToChange ]
@export var attributes: Dictionary
@onready var label = $InteractLabel 

func _ready():
    label.visible = false
    add_to_group("Objects")
    
    for attr in attributes :
        if attr == "Collision" :
            $TreeHitbox/CollisionShape2D.disabled = !attributes[attr]

func _on_tree_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        label.visible = true
        player_entered_tree = true
    
func _on_tree_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        label.visible = false
        player_entered_tree = false
        tablet_visible = false
        emit_signal("toggle_tablet", tablet_visible)



func update_attr(key, value) :
    print("Old: ", attributes)
    attributes[key] = value
    print("new: ", attributes)


func _on_tree_area_mouse_entered() -> void:
    mouse_entered_tree = true
    if player_entered_tree :
        Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        
func _on_tree_area_mouse_exited() -> void:
    mouse_entered_tree = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") : 
        # toggle the visibility
        if mouse_entered_tree and player_entered_tree:
            tablet_visible = !tablet_visible
            
        # when player click anywhere else + player not in range ig
        elif !(mouse_entered_tree or player_entered_tree) :
            tablet_visible = false

        emit_signal("toggle_tablet", tablet_visible)
