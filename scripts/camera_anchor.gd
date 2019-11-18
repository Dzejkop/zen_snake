extends Spatial

export var speed = 0.1

func _process(delta):
    transform = transform.rotated(Vector3.UP, delta * speed)
