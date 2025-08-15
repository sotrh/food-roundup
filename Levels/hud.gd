extends Control

@export var types: Array[IngredientType];

@onready var carrot_label = $MarginContainer/Pack/CarrotLabel;
@onready var tomato_label = $MarginContainer/Pack/TomatoLabel;

func _process(delta: float) -> void:
	if Global.game.pack.has(0):
		carrot_label.text = "%d" % Global.game.pack[0];
	if Global.game.pack.has(1):
		tomato_label.text = "%d" % Global.game.pack[1];
	pass

