extends Node2D

signal toggle_tablet(toggle: bool)

var mouse_entered_vines  := false
var player_entered_vines := false
var tablet_visible       := false

# Dict => Attr_Name : [type(bool, int, str), whatToChange ]
@export var attributes: Dictionary
@onready var label_anim = $Icon/IconTexture/AnimationPlayer
@onready var texture = $Fire/Texture
@onready var timer = $Fire/Timer


func _ready():
    #hint.visible = false
    texture.visible = false
    add_to_group("Objects")
    add_to_group("Vines")
    timer.connect("timeout", on_timeout)
    
    for attr in attributes :
        if attr == "Collision" :
            $Hitbox/CollisionShape2D.disabled = !attributes[attr]
            
    attributes = attributes.duplicate(true)


func _on_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        #hint.visible = true
        label_anim.play("popout")
        player_entered_vines = true
    
func _on_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        #hint.visible = false
        label_anim.play_backwards("popout")
        player_entered_vines = false
        tablet_visible = false
        emit_signal("toggle_tablet", false)


func _on_area_mouse_entered() -> void:
    mouse_entered_vines = true
    if player_entered_vines :
        Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        
func _on_area_mouse_exited() -> void:
    mouse_entered_vines = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func update_attr(key, value) :
    attributes[key] = value

func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") : 
        # toggle the visibility
        if mouse_entered_vines and player_entered_vines:
            tablet_visible = !tablet_visible
            emit_signal("toggle_tablet", tablet_visible)
            
    elif evt.is_action_pressed("rightClick") and attributes["Flammable"] :
        if mouse_entered_vines and player_entered_vines and !texture.visible:
            texture.visible = true
            $Sprite2D.modulate = Color(0.969, 0.153, 0.0, 1.0)
            timer.start()

func on_timeout() -> void:
    timer.stop()
    $Sprite2D.visible = false
    $Icon.visible = false
    texture.visible = false
    $Explosion.emitting = true
    $Hitbox/CollisionShape2D.disabled = true
    $Area/CollisionShape2D.disabled = true
    $Range/CollisionShape2D.disabled = true


func _on_explosion_finished() -> void:
    queue_free()
