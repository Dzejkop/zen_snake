extends Spatial

export var axis := Vector3.UP
export var speed := 1.0

func _process(delta):
    rotate(axis, speed * delta)
