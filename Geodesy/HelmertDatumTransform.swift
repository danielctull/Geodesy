
/// Transforms to apply to coordinates.
public struct HelmertDatumTransform {
	let transformX: Double
	let transformY: Double
	let transformZ: Double
	let rotateX: Double
	let rotateY: Double
	let rotateZ: Double
	let scale: Double
}



extension HelmertDatumTransform {

	/// Get the inverse of this transform.
	public var inverse: HelmertDatumTransform {
		return HelmertDatumTransform(
			transformX: -transformX,
			transformY: -transformY,
			transformZ: -transformZ,
			rotateX: -rotateX,
			rotateY: -rotateY,
			rotateZ: -rotateZ,
			scale: -scale)
	}
}



/// https://en.wikipedia.org/wiki/Helmert_transformation#Standard_parameters
extension HelmertDatumTransform {

	public static var wgs84osgb36: HelmertDatumTransform {
		return HelmertDatumTransform(
			transformX: -446.448,
			transformY: 125.157,
			transformZ: -542.060,
			rotateX: -0.1502,
			rotateY: -0.2470,
			rotateZ: -0.8421,
			scale: 20.4894)
	}

	public static var osgb36wgs84: HelmertDatumTransform {
		return wgs84osgb36.inverse
	}
}
