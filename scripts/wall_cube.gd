extends MeshInstance

export var color_active := Color.red
export var color_inactive := Color.black
export var color_semiactive := Color.yellow

export var energy_active := 10.0
export var energy_inactive := 1.0
export var energy_semiactive := 1.0

export var lerp_speed := 0.1

var current_state = State.Inactive

enum State {
    Active,
    Inactive,
    Semi
}

onready var mat: SpatialMaterial = get_surface_material(0)
    
func set_active():
    current_state = State.Active

func set_inactive():
    current_state = State.Inactive
    
func set_semi():
    current_state = State.Semi
    
func change_state():
    if Input.is_action_just_pressed("ui_accept"):
        print('Changing state')
        if current_state == State.Semi:
            current_state = State.Active
            return

        if current_state == State.Inactive:
            current_state = State.Semi
            return

        if current_state == State.Active:
            current_state = State.Inactive
            return

func _process(_delta):
    change_state()

    if current_state == State.Active:
        mat.emission_energy = lerp(mat.emission_energy, energy_active, lerp_speed)
        mat.emission = mat.emission.linear_interpolate(color_active, lerp_speed)
    
    if current_state == State.Inactive:
        mat.emission_energy = lerp(mat.emission_energy, energy_inactive, lerp_speed)
        mat.emission = mat.emission.linear_interpolate(color_inactive, lerp_speed)
        
    if current_state == State.Semi:
        mat.emission_energy = lerp(mat.emission_energy, energy_semiactive, lerp_speed)
        mat.emission = mat.emission.linear_interpolate(color_semiactive, lerp_speed)
