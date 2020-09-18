
public struct Ellipsoid: Equatable {
    public let semiMajorAxis: Double
    public let semiMinorAxis: Double
    public let inverseFlattening: Double
}

extension Ellipsoid {

    public static var wgs84: Ellipsoid {
        Ellipsoid(semiMajorAxis: 6378137, semiMinorAxis: 6356752.3142, inverseFlattening: 1 / 298.257223563)
    }

    public static var grs80: Ellipsoid {
        Ellipsoid(semiMajorAxis: 6378137, semiMinorAxis: 6356752.314140, inverseFlattening: 1 / 298.257222101)
    }

    public static var airy1830: Ellipsoid {
        Ellipsoid(semiMajorAxis: 6377563.396, semiMinorAxis: 6356256.910, inverseFlattening: 1 / 299.3249646)
    }

    public static var airyModified: Ellipsoid {
        Ellipsoid(semiMajorAxis: 6377340.189, semiMinorAxis: 6356034.448, inverseFlattening: 1 / 299.32496)
    }

    public static var intl1924: Ellipsoid {
        Ellipsoid(semiMajorAxis: 6378388.000, semiMinorAxis: 6356911.946, inverseFlattening: 1 / 297.0)
    }
}
