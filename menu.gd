extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	# TODO: Change this with actual main scene when we have :D
	get_tree().change_scene_to_file("res://Level/TempMain.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
