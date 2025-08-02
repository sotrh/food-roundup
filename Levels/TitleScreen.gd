extends CenterContainer

@export var music: AudioStream;

func _input(event: InputEvent) -> void:
	#event.remove_user_signal(
	if event is InputEventMouseMotion:
		return
		
	Global.game.start_game();
	queue_free()

func _ready() -> void:
	Global.game.play_music(music);
