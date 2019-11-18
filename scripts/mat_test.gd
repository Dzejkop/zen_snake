extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var mesh := $mesh
var mat: Material
var t: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    mat = mesh.get_surface_material(0) as SpatialMaterial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    t += delta
    
    mat.emission_energy = sin(t) * 2.0
