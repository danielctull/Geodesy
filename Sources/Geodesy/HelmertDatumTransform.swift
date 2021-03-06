
/// Transforms to apply to coordinates.
public struct HelmertDatumTransform {
    public let transformX: Double
    public let transformY: Double
    public let transformZ: Double
    public let rotateX: Double
    public let rotateY: Double
    public let rotateZ: Double
    public let scale: Double

    /// The accuracy of a conversion performed
    public let accuracy: Double
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
            scale: -scale,
            accuracy: accuracy)
    }
}

/// https://en.wikipedia.org/wiki/Helmert_transformation#Standard_parameters
extension HelmertDatumTransform {

    fileprivate static var identity: HelmertDatumTransform {
        HelmertDatumTransform(
            transformX: 0,
            transformY: 0,
            transformZ: 0,
            rotateX: 0,
            rotateY: 0,
            rotateZ: 0,
            scale: 1,
            accuracy: 0)
    }

    fileprivate static var wgs84osgb36: HelmertDatumTransform {
        HelmertDatumTransform(
            transformX: -446.448,
            transformY: 125.157,
            transformZ: -542.060,
            rotateX: -0.1502,
            rotateY: -0.2470,
            rotateZ: -0.8421,
            scale: 20.4894,
            accuracy: 5) // According to the OS
    }

    fileprivate static var osgb36wgs84: HelmertDatumTransform {
        wgs84osgb36.inverse
    }
}

extension HelmertDatumTransform {

    public init(from: Datum, to: Datum) {

        switch (from, to) {

        // If it's the same
        case (.wgs84, .wgs84): self = .identity
        case (.osgb36, .osgb36): self = .identity

        case (.wgs84, .osgb36): self = .wgs84osgb36
        case (.osgb36, .wgs84): self = .osgb36wgs84
        }
    }
}
