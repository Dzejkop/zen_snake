extends "res://scripts/segment.gd"

func _ready():
    pass

func _on_death():
    $animation.play("death")

