
public struct Coordinate {

	public let latitude: Double
	public let longitude: Double
	public let system: CoordinateSystem

	public init(latitude: Double, longitude: Double, system: CoordinateSystem = .wgs84) {
		self.latitude = latitude
		self.longitude = longitude
		self.system = system
	}
}
