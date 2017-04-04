
// http://www.movable-type.co.uk/scripts/latlong.html

extension Coordinate {

	public func initialHeading(to coordinate: Coordinate) -> Double {

		let from = convert(to: .wgs84)
		let to = coordinate.convert(to: .wgs84)

		let fromLatitude = radians(from: from.latitude)
		let fromLongitude = radians(from: from.longitude)
		let toLatitude = radians(from: to.latitude)
		let toLongitude = radians(from: to.longitude)

		let dLongitude = toLongitude - fromLongitude

		let dy = sin(dLongitude) * cos(toLatitude)
		let dx = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(dLongitude)
		let angle = atan2(dy, dx)
		return degrees(from: angle)
	}
}
