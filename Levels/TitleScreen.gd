extends CenterContainer

@export var game_ui: PackedScene;

@export var music: AudioStream;
@export var music2: AudioStream;

func _input(event: InputEvent) -> void:
	#event.remove_user_signal(
	if event is InputEventMouseMotion:
		return
		
	Global.game.start_game();
	Global.game.load_ui(game_ui);
	queue_free()

func _ready() -> void:
	Global.game.play_music(music);
	Global.game.play_music(music2);
