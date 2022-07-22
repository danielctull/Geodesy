
import Foundation

public struct Coordinate {

    public let latitude: Angle
    public let longitude: Angle
    public let accuracy: Double
    public let datum: Datum

    public init(latitude: Angle, longitude: Angle, accuracy: Double = 0, datum: Datum = .wgs84) {
        self.latitude = latitude
        self.longitude = longitude
        self.datum = datum
        self.accuracy = accuracy
    }
}

extension Coordinate {

    public func convert(to new: Datum) -> Coordinate {

        // -- 1: convert polar to cartesian coordinates (using ellipse 1)
        // -- 2: apply helmert transform to WGS84
        // -- 3: apply new system's helmert transform from WGS84
        // -- 4: convert cartesian to polar coordinates (using ellipse 2)

        let p = cartesianCoordinates(using: datum.ellipsoid)
            .apply(datum.toWGS84)
            .apply(new.fromWGS84)
            .polarCoordinates(using: new.ellipsoid)

        return Coordinate(
            latitude: p.0,
            longitude: p.1,
            accuracy: accuracy + datum.toWGS84.accuracy + new.fromWGS84.accuracy,
            datum: new)
    }
}
