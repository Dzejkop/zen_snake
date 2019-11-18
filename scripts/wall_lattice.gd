extends Spatial

onready var mesh: Spatial = $Cube
onready var mat: SpatialMaterial = mesh.get_surface_material(0)

var target_transparency := 0.0
var _current_transparency := 1.0

func update_transparency(transparency: float):
    target_transparency = transparency

func _process(delta):
    _current_transparency = lerp(_current_transparency, target_transparency, 0.5)
    
    var new_color := mat.albedo_color
    new_color.a = _current_transparency
    mat.albedo_color = new_color
