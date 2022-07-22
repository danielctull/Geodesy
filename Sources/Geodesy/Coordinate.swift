
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

        // -- 1: convert polar to cartesian coordinates (using ellipse 1)
        // -- 2: apply helmert transform to WGS84
        // -- 3: apply new system's helmert transform from WGS84
        // -- 4: convert cartesian to polar coordinates (using ellipse 2)

        let p = cartesianCoordinates(using: system.ellipsoid)
            .apply(system.datum.toWGS84)
            .apply(newSystem.datum.fromWGS84)
            .polarCoordinates(using: newSystem.ellipsoid)

        return Coordinate(
            latitude: p.0,
            longitude: p.1,
            accuracy: accuracy + system.datum.toWGS84.accuracy + newSystem.datum.fromWGS84.accuracy,
            system: newSystem)
    }
}
