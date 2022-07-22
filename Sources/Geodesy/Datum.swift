
public struct Datum: Equatable {
    let fromWGS84: HelmertTransform
}

extension Datum {

    var toWGS84: HelmertTransform { fromWGS84.inverse }

    init(toWGS84: HelmertTransform) {
        self.init(fromWGS84: toWGS84.inverse)
    }
}

extension Datum {

    static let wgs84 = Datum(fromWGS84: .identity)

    // According to the OS
    static let osgb36 = Datum(fromWGS84: HelmertTransform(
        translateX: -446.448,
        translateY: 125.157,
        translateZ: -542.060,
        rotateX: .arcseconds(-0.1502),
        rotateY: .arcseconds(-0.2470),
        rotateZ: .arcseconds(-0.8421),
        scale: 20.4894,
        accuracy: 5))
}
