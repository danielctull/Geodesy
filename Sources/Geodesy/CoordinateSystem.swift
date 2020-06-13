
public struct CoordinateSystem: Equatable {
	public let datum: Datum
	public let ellipsoid: Ellipsoid
}

extension CoordinateSystem {

	public static var wgs84: CoordinateSystem {
		CoordinateSystem(datum: .wgs84, ellipsoid: .wgs84)
	}

	public static var osgb36: CoordinateSystem {
		CoordinateSystem(datum: .osgb36, ellipsoid: .airy1830)
	}
}
