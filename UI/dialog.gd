extends Control

@export var scene_text_file: String

var scene_text = {}
var selected_text = []
var in_progress = false
var is_typing = false

@onready var frame = $Frame
@onready var textlabel = $Frame/Text
@onready var animation = $AnimationPlayer

func _ready():
    self.visible = false
    scene_text = load_em_text()
    DialogManager.connect("display_dialog", on_display_dialog)
    
func load_em_text():
    if scene_text_file:
        var json = JSON.new()
        var string = FileAccess.open(scene_text_file, FileAccess.READ).get_as_text()
        var error = json.parse(string)
        if error == OK:
            return json.data
        else:
            return

func show_text():
    var text = selected_text.pop_front()
    is_typing = true
    await type_text(text)
    is_typing = false

    
func type_text(text: String) -> void:
    for i in text.length():
        if !is_typing:
            textlabel.text = text
            return
        var current_text = text.substr(0, i + 1)
        textlabel.text = current_text
        $AudioStreamPlayer2D.play(0.15)
        await get_tree().create_timer(.03).timeout
        
func next_line():
    if selected_text.size() > 0:
        show_text()
    else:
        finish()
        
func finish():
    animation.play("close")
    

func on_display_dialog(dialog):
    if in_progress:
        if is_typing:
            is_typing = false
            return
        next_line()
    else:
        animation.play("open")
        get_tree().paused = true
        self.visible = true
        in_progress = true
        selected_text = scene_text[dialog].duplicate()
        print(selected_text)
        show_text()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "close":
        textlabel.text = ""
        get_tree().paused = false
        self.visible = false
        in_progress = false
        
