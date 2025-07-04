extends Node2D

var mouse_entered_tree  := false
var player_entered_tree := false
var tablet_visible      := false

@onready var label = $InteractLabel
@export var dialog: String

func _ready():
    label.visible = false
    
func _on_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        label.visible = true
        player_entered_tree = true
    
func _on_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        label.visible = false
        player_entered_tree = false
        tablet_visible = false
        #emit_signal("toggle_tablet", tablet_visible)

func _on_area_mouse_entered() -> void:
    mouse_entered_tree = true
    if player_entered_tree :
        Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        
func _on_area_mouse_exited() -> void:
    mouse_entered_tree = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") : 
        # toggle the visibility
        if mouse_entered_tree and player_entered_tree:
            tablet_visible = !tablet_visible
            DialogManager.emit_signal("display_dialog", dialog)
