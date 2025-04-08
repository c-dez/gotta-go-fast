extends Label
### DEBUG

	
func _process(_delta):
	text = "FPS: %d" % Engine.get_frames_per_second()
	# print(_delta)
	
