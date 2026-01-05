extends SubViewportContainer

@onready var vp := $SubViewport

func _ready():
	vp.size = size

func _notification(what):
	if !vp: return
	if what == NOTIFICATION_RESIZED:
		vp.size = size
