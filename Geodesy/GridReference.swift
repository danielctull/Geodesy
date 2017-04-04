
public protocol GridReference {
	var region: String { get }
	var easting: Int { get }
	var northing: Int { get }
	var accuracy: Int { get }
}
