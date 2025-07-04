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

#show the current text and remove it from the list for the next text.
func show_text():
    var text = selected_text.pop_front()
    is_typing = true
    await type_text(text)
    is_typing = false
    

#typewriter animation and sound effect (will be cancelled if clicked during animation)
func type_text(text: String) -> void:
    for i in text.length():
        if !is_typing:
            textlabel.text = text
            return
        var current_text = text.substr(0, i + 1)
        textlabel.text = current_text
        $AudioStreamPlayer.play(0)
        await get_tree().create_timer(.03).timeout

#check if dialog isn't finished
func next_line():
    if selected_text.size() > 0:
        show_text()
    else:
        finish()

#close the dialog
func finish():
    animation.play("close")
    
#on signal call function
func on_display_dialog(dialog):
    if in_progress:
        return
    else:
        get_tree().paused = true
        self.visible = true
        selected_text = scene_text[dialog].duplicate()
        print(selected_text)
        show_text()
        in_progress = true

#handle input on everywhere
func _input(evt) -> void:
    if in_progress:
        if !animation.is_playing():
            if evt.is_action_pressed("leftClick"):
                if is_typing: 
                    is_typing = false
                else:
                    next_line()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "close":
        textlabel.text = ""
        get_tree().paused = false
        self.visible = false
        in_progress = false
