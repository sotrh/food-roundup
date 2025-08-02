class_name SoundPack extends Resource

@export var flee_sounds: Array[AudioStream];
@export var surprise_sounds: Array[AudioStream];

func random_flee_sound() -> AudioStream:
	return flee_sounds.pick_random();

func random_surprise_sound() -> AudioStream:
	return surprise_sounds.pick_random();
