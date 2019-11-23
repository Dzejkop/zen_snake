extends Spatial

var _target_pos: Vector3

export var start_visible = false

var is_dead := false

func _ready():
    _target_pos = translation
    if not start_visible:
        $animation.play("appear")

func _orient(forward: Vector3, normal: Vector3):
    look_at(forward, normal)

func update_pos(translation: Vector3):
    _target_pos = translation

func translate_pos(forward: Vector3):
    _target_pos += forward.normalized() * 2

func _process(_delta):
    translation = translation.linear_interpolate(_target_pos, 0.5)

    if is_dead:
        var mat = $mesh.get_surface_material(0)
        mat.albedo_color = mat.albedo_color.linear_interpolate(Color.white, 0.001)

func die():
    is_dead = true
