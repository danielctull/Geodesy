
// http://www.movable-type.co.uk/scripts/latlong.html

import Foundation

extension Coordinate {

    public func initialHeading(to coordinate: Coordinate) -> Angle {

        let from = convert(to: .wgs84)
        let to = coordinate.convert(to: .wgs84)

        let fromLatitude = from.latitude.radians
        let fromLongitude = from.longitude.radians
        let toLatitude = to.latitude.radians
        let toLongitude = to.longitude.radians

        let dLongitude = toLongitude - fromLongitude

        let dy = sin(dLongitude) * cos(toLatitude)
        let dx = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(dLongitude)
        let angle = atan2(dy, dx)
        return .radians(angle)
    }

    public func distance(to coordinate: Coordinate) -> Double {

        let from = convert(to: .wgs84)
        let to = coordinate.convert(to: .wgs84)

        let r: Double = 6371000		// Radius of Earth in meters

        let fromLatitude = from.latitude.radians
        let fromLongitude = from.longitude.radians
        let toLatitude = to.latitude.radians
        let toLongitude = to.longitude.radians

        let dLongitude = toLongitude - fromLongitude
        let dLatitude = toLatitude - fromLatitude

        let sinDLatitude2 = sin(dLatitude / 2)
        let sinDLongitude2 = sin(dLongitude / 2)

        let a = sinDLatitude2 * sinDLatitude2 + sinDLongitude2 * sinDLongitude2 * cos(fromLatitude) * cos(toLatitude)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return r * c
    }
}
