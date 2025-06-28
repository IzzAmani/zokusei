extends Node2D

var mouse_entered_chest  := false
var player_entered_chest := false

# Dict => Attr_Name : [type(bool, int, str), whatToChange ]
@export var items: Dictionary

func _ready():
    add_to_group("Chests")
    
    for attr in items:
        pass


func _on_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        player_entered_chest = true
    
func _on_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        player_entered_chest = false
                
        
func _on_area_mouse_entered() -> void:
    mouse_entered_chest = true
    if player_entered_chest :
        Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
        
func _on_area_mouse_exited() -> void:
    mouse_entered_chest = false
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") : 
        # toggle the visibility
        if mouse_entered_chest and player_entered_chest :
            $Sprite2D.texture = load("res://Arts/ChestOpen.png")
            $Particles.emitting = true
            $AnimationPlayer.play("FadeOut")
        
        #elif mouse_entered_chest and player_entered_chest :
            #$Sprite2D.texture = load("res://Arts/Chest.png")
            #modulate.a = 1
            #$Hitbox/CollisionShape2D.disabled = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "FadeOut" :
        $Hitbox/CollisionShape2D.disabled = true
