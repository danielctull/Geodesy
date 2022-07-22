
public struct CoordinateSystem: Equatable {
    public let datum: Datum
    public let ellipsoid: Ellipsoid
}

extension CoordinateSystem {

    public static let wgs84 = CoordinateSystem(
        datum: .wgs84,
        ellipsoid: .wgs84)

    public static let osgb36 = CoordinateSystem(
        datum: .osgb36,
        ellipsoid: .airy1830)
}
