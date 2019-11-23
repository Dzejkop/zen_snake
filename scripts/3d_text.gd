extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    var mat: SpatialMaterial = get_surface_material(0)
    var tex = $viewport.get_texture()
    mat.albedo_texture = tex
    mat.emission_texture = tex
    
func set_text(text: String):
    $viewport/text_display.set_text(text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
