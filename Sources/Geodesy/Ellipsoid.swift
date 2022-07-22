
public struct Ellipsoid: Equatable {
    public let semiMajorAxis: Double
    public let semiMinorAxis: Double
    public let inverseFlattening: Double
}

extension Ellipsoid {

    public static let wgs84 = Ellipsoid(
        semiMajorAxis: 6378137,
        semiMinorAxis: 6356752.3142,
        inverseFlattening: 1 / 298.257223563)

    public static let grs80 = Ellipsoid(
        semiMajorAxis: 6378137,
        semiMinorAxis: 6356752.314140,
        inverseFlattening: 1 / 298.257222101)

    public static var airy1830 = Ellipsoid(
        semiMajorAxis: 6377563.396,
        semiMinorAxis: 6356256.910,
        inverseFlattening: 1 / 299.3249646)

    public static let airyModified = Ellipsoid(
        semiMajorAxis: 6377340.189,
        semiMinorAxis: 6356034.448,
        inverseFlattening: 1 / 299.32496)

    public static let intl1924 = Ellipsoid(
        semiMajorAxis: 6378388.000,
        semiMinorAxis: 6356911.946,
        inverseFlattening: 1 / 297.0)
}
