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
    TreeNode = $Node2D/Tree
    TabletNode = $UI/Tablet
    TransitionBG = $UI/Transition/ColorRect
    TransitionAnim = TransitionBG.get_node("AnimationPlayer")

    TabletNode.visible = false
    TransitionBG.modulate.a = 0
    
    # Toggle Tablet Visibility
    TreeNode.player_enter.connect(
        func (show: bool) :
            TabletNode.visible = show    
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
    TransitionAnim.animation_finished.connect(_on_animation_finished)
    

func _on_animation_finished(name: String) -> void :
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
