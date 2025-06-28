extends Node

signal changeMap

var PlayerNode : Node
var CameraNode : Node
var TreeNode : Node 
var TabletNode : Node
var TransitionBG : Node
var TransitionAnim : Node

var player_direction := Vector2(0, 0)
var current_room := Vector2(0, 0)
@onready var room_size = $Node2D/MainMap.get_used_rect().size * 64

func change_camera(room: Vector2) :
    CameraNode.limit_left  = room.x * room_size.x
    CameraNode.limit_right = CameraNode.limit_left + room_size.x
    
    CameraNode.limit_top    = room.y * room_size.y
    CameraNode.limit_bottom = CameraNode.limit_top + room_size.y
    
    
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    PlayerNode = $Node2D/Player
    CameraNode = $Node2D/Player/Camera2D
    TabletNode = $UI/Tablet
    TransitionBG = $UI/Transition/ColorRect
    TransitionAnim = TransitionBG.get_node("AnimationPlayer")

    TabletNode.visible = false
    TransitionBG.modulate.a = 0
    $UI/HurtScr/ColorRect.modulate.a = 0
    
    # Toggle Tablet Visibility
    for object in get_tree().get_nodes_in_group("Objects") :
        object.toggle_tablet.connect(
            func (show: bool) :
                TabletNode.visible = show    
                update_tablet_scr(object, show)
        )
    
    # Camera clamping
    change_camera(current_room)    
    
    # transition animation
    for door in get_tree().get_nodes_in_group("Doors") :
        door.change_room.connect(
            func (p_dir: Vector2) :
                PlayerNode.speed = 0
                player_direction = p_dir
                TransitionAnim.play("FadeIn")
                
                current_room += p_dir
        )
    TransitionAnim.animation_finished.connect(animation_finished)
    
    

func animation_finished(name: String) -> void :
    if name == "FadeIn" :
        PlayerNode.position += player_direction * 64 * 5.5
        change_camera(current_room)
        TransitionAnim.play("FadeOut")
    
    elif name == "FadeOut" :
        PlayerNode.speed = 400
    
    
# For toggling fulll screen with F11
func _input(evt) -> void:
    if evt.is_action_pressed("toggleFullscr") :
        if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN :
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        else :
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


# Updating the tablet after every pressed
var prev_object: Node = null
func update_tablet_scr(object, show) -> void :
    var tablet_scr = $UI/Tablet/Panel/TabletScreen
    
    if object == prev_object or !show :
       return 
        
    prev_object = object
    
    # delete every inputs in queue
    for inputs in tablet_scr.get_children() :
        inputs.queue_free()
        
    # add new inputs
    for attr_key in object.attributes :
        var attr_value = object.attributes[attr_key]
        
        var new_attr = VBoxContainer.new()
        var attr_label = Label.new()
        var attr_input: Node
            
        # Add label
        attr_label.text = attr_key + ": "
        attr_label.add_theme_font_size_override("font_size", 69)
        new_attr.add_child(attr_label)    
        
        # Add input based on type
        if typeof(attr_value) == TYPE_BOOL :
            attr_input = Button.new()
            attr_input.text = "Enabled" if attr_value else "Disabled"
            
            attr_input.pressed.connect(update_button.bind(object, attr_key, attr_input))
            
            
        elif typeof(attr_value) == TYPE_INT :
            attr_input = SpinBox.new()
            attr_input.min_value = 0
            attr_input.max_value = 100
        
        else :
            attr_input = Button.new()
            attr_input.text = "HI"
            
        attr_input.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        new_attr.add_child(attr_input)
        
        # Add the attr line onto the tablet screen
        tablet_scr.add_child(new_attr)
        new_attr.add_to_group("Buttons")


# Updating the button
func update_button(obj, key, btn) :
    if typeof(obj.attributes[key]) == TYPE_BOOL :
        obj.update_attr(key, !obj.attributes[key])  # Toggle the disability
        btn.text = "Enabled" if obj.attributes[key] else "Disabled"
        
        # Toggle hitbox colliision
        if key == "Collision" :
            obj.get_node("Hitbox/CollisionShape2D").disabled = !obj.attributes[key]

        # Toggle if something can be burn off        
        if key == "Flammable" :
            pass
        
