
import Foundation

public struct Coordinate {

    public let latitude: Angle
    public let longitude: Angle
    public let accuracy: Double
    public let system: CoordinateSystem

    public init(latitude: Angle, longitude: Angle, accuracy: Double = 0, system: CoordinateSystem = .wgs84) {
        self.latitude = latitude
        self.longitude = longitude
        self.system = system
        self.accuracy = accuracy
    }
}

extension Coordinate {

    public func convert(to newSystem: CoordinateSystem) -> Coordinate {

        let transform = HelmertTransform(from: system.datum, to: newSystem.datum)

        // -- 1: convert polar to cartesian coordinates (using ellipse 1)

        let e1 = system.ellipsoid
        let e2 = newSystem.ellipsoid

        var a = e1.semiMajorAxis
        var b = e1.semiMinorAxis

        let sinPhi = sin(latitude.radians)
        let cosPhi = cos(latitude.radians)
        let sinLambda = sin(longitude.radians)
        let cosLambda = cos(longitude.radians)
        var H = 24.7  // for the moment

        var eSq = (a * a - b * b) / (a * a)
        var nu = a / sqrt(1 - eSq * sinPhi * sinPhi)

        let x1 = (nu + H) * cosPhi * cosLambda
        let y1 = (nu + H) * cosPhi * sinLambda
        let z1 = ((1 - eSq) * nu + H) * sinPhi

        // -- 2: apply helmert transform using appropriate params

        let position = CartesianCoordinate3D(x: x1, y: y1, z: z1).apply(transform)

        // -- 3: convert cartesian to polar coordinates (using ellipse 2)

        a = e2.semiMajorAxis
        b = e2.semiMinorAxis
        let precision = 4 / a;  // results accurate to around 4 metres

        eSq = (a * a - b * b) / (a * a)
        let p = sqrt(position.x * position.x + position.y * position.y)
        var phi = atan2(position.z, p * (1 - eSq))
        var phiP = 2 * Double.pi

        while fabs(phi - phiP) > precision {
            nu = a / sqrt(1 - eSq * sin(phi) * sin(phi))
            phiP = phi
            phi = atan2(position.z + eSq * nu * sin(phi), p)
        }

        let lambda = atan2(position.y, position.x)
        H = p / cos(phi) - nu

        return Coordinate(
            latitude: .radians(phi),
            longitude: .radians(lambda),
            accuracy: accuracy + transform.accuracy,
            system: newSystem)
    }
}
