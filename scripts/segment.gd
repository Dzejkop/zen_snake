extends Spatial

var _target_pos: Vector3

export var start_visible = false

var is_dead := false

var _snake = null

func _ready():
    _target_pos = translation
    _snake = $".."
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
        pass
#        var mat: ShaderMaterial = $mesh.get_surface_material(0)
#        var ratio = mat.get_shader_param("ratio")
#        if ratio:
#            mat.set_shader_param("ratio", lerp(ratio, 0, 0.01))

func die():
    is_dead = true
