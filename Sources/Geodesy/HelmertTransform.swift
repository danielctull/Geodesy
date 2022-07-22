
/// Transforms to apply to coordinates.
public struct HelmertTransform: Equatable {
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

    public static let identity = HelmertTransform(
        translateX: 0,
        translateY: 0,
        translateZ: 0,
        rotateX: .arcseconds(0),
        rotateY: .arcseconds(0),
        rotateZ: .arcseconds(0),
        scale: 1,
        accuracy: 0)

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
