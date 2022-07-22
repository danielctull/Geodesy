
/// Transforms to apply to coordinates.
public struct HelmertTransform {
    public let translateX: Double
    public let translateY: Double
    public let translateZ: Double
    public let rotateX: Angle
    public let rotateY: Angle
    public let rotateZ: Angle
    public let scale: Double

    /// The accuracy of a conversion performed
    public let accuracy: Double
}

extension HelmertTransform {

    /// Get the inverse of this transform.
    public var inverse: HelmertTransform {
        HelmertTransform(
            translateX: -translateX,
            translateY: -translateY,
            translateZ: -translateZ,
            rotateX: -rotateX,
            rotateY: -rotateY,
            rotateZ: -rotateZ,
            scale: -scale,
            accuracy: accuracy)
    }
}

/// https://en.wikipedia.org/wiki/Helmert_transformation#Standard_parameters
extension HelmertTransform {

    fileprivate static let identity = HelmertTransform(
            translateX: 0,
            translateY: 0,
            translateZ: 0,
            rotateX: .arcseconds(0),
            rotateY: .arcseconds(0),
            rotateZ: .arcseconds(0),
            scale: 1,
            accuracy: 0)

    fileprivate static let wgs84osgb36 = HelmertTransform(
            translateX: -446.448,
            translateY: 125.157,
            translateZ: -542.060,
            rotateX: .arcseconds(-0.1502),
            rotateY: .arcseconds(-0.2470),
            rotateZ: .arcseconds(-0.8421),
            scale: 20.4894,
            accuracy: 5) // According to the OS
}

extension HelmertTransform {

    public init(from: Datum, to: Datum) {

        switch (from, to) {

        // If it's the same
        case (.wgs84, .wgs84): self = .identity
        case (.osgb36, .osgb36): self = .identity

        case (.wgs84, .osgb36): self = HelmertTransform.wgs84osgb36
        case (.osgb36, .wgs84): self = HelmertTransform.wgs84osgb36.inverse
        }
    }
}
