extends Spatial

export(Color) var _albedo;

func _ready():
	var _cover_material: SpatialMaterial = SpatialMaterial.new()
	_cover_material.albedo_color = _albedo;
	$"BookMesh/Spine/Spine".material_override = _cover_material;
	$"BookMesh/BackRotationPivot/BackCover/Cover".material_override = _cover_material;
	$"BookMesh/FrontRotationPivot/FrontCover/Cover".material_override = _cover_material;
