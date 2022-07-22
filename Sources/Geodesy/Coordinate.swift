
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
        // -- 2: apply helmert transform using appropriate params
        // -- 3: convert cartesian to polar coordinates (using ellipse 2)

        let p = cartesianCoordinates(using: system.ellipsoid)
            .apply(transform)
            .polarCoordinates(using: newSystem.ellipsoid)

        return Coordinate(
            latitude: p.0,
            longitude: p.1,
            accuracy: accuracy + transform.accuracy,
            system: newSystem)
    }
}
