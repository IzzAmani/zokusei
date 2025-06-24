extends Area2D

@export var endDoorPath: NodePath
var endDoor: Marker2D

func _ready():
	if endDoorPath:
		endDoor = get_node(endDoorPath)
	else:
		push_error("END DOOR PATH NOT DEFINED")
		
func _on_body_entered(body: Node2D) :
	if body.name != "Player" :
		return
		
	if endDoor:
		body.global_position = endDoor.global_position
		
	
