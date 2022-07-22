
public struct Datum: Equatable {
    let ellipsoid: Ellipsoid
    let fromWGS84: HelmertTransform
}

extension Datum {

    var toWGS84: HelmertTransform { fromWGS84.inverse }
}

extension Datum {

    public static let wgs84 = Datum(
        ellipsoid: .wgs84,
        fromWGS84: .identity)

    public static let osgb36 = Datum(
        ellipsoid: .airy1830,
        fromWGS84: HelmertTransform(
            translateX: -446.448,
            translateY: 125.157,
            translateZ: -542.060,
            rotateX: .arcseconds(-0.1502),
            rotateY: .arcseconds(-0.2470),
            rotateZ: .arcseconds(-0.8421),
            scale: 20.4894,
            accuracy: 5))
}
