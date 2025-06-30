extends Node2D

var mouse_entered_chest  := false
var player_entered_chest := false

# Dict => Attr_Name : [type(bool, int, str), whatToChange ]
@export var items: Dictionary = {
    "texture": ""
}

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


var chest_opened = false
var item = Node2D.new()
func _input(evt) -> void :
    if evt.is_action_pressed("leftClick") and !chest_opened: 
        # toggle the visibility
        if mouse_entered_chest and player_entered_chest :
            $Sprite2D.texture = load("res://Arts/ChestOpen.png")
            $Particles.emitting = true
            $AnimationPlayer.play("FadeOut")
            chest_opened = true
            
            #print("clicking ", items.texture )
            #var item = Node2D.new()
            #var item_texture = Sprite2D.new()
            #item.global_position = position
            #
            #item_texture.texture = load(items.texture) # items.texture == res://Arts/script.png
            #
            #item.add_child(item_texture)
            #add_child(item)
            #
            #print(item.position)
            
            var sprite = Sprite2D.new()
            sprite.texture = load(items.texture)
            item.add_child(sprite)
            
            item.visible = true
            
            GlobalVariables.items_acquired[items.name] = true

            # Defer adding to ensure correct initialization
            $"../".add_child(item)
            item.global_position = global_position  # or target Vector2
            item.z_index = 1
            # Create a Tween for a "spit out" effect
            var tween = create_tween()
            tween.set_trans(Tween.TRANS_CUBIC)
            tween.set_ease(Tween.EASE_IN_OUT)
            
            tween.tween_property(item, "position", item.position + Vector2(0, -64), 0.25)
            tween.tween_interval(0.5)
            tween.tween_property(item, "modulate", Color(1, 1, 1, 0), 0.25)
            tween.parallel().tween_property(item, "position", get_tree().root.get_node("Main/Node2D/Player").position, 0.25)
            
        #elif mouse_entered_chest and player_entered_chest :
            #$Sprite2D.texture = load("res://Arts/Chest.png")
            #modulate.a = 1
            #$Hitbox/CollisionShape2D.disabled = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "FadeOut" :
        $Hitbox/CollisionShape2D.disabled = true
        $Area/CollisionShape2D.disabled = true
        $Range/CollisionShape2D.disabled = true
        
