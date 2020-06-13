
import Geodesy
import XCTest

final class CoordinateDirectionsTests: XCTestCase {

	func testHeading() {
		let coordinate1 = Coordinate(latitude: 50.887205, longitude: -0.66426516)
		let coordinate2 = Coordinate(latitude: 50.894487, longitude: -0.64822286)
		let heading = coordinate1.initialHeading(to: coordinate2)
		XCTAssertEqual(heading, 54.255, accuracy: 1e-4)
	}

	func testDistance() {
		let coordinate1 = Coordinate(latitude: 50.887205, longitude: -0.66426516)
		let coordinate2 = Coordinate(latitude: 50.894487, longitude: -0.64822286)
		let distance = coordinate1.distance(to: coordinate2)
		XCTAssertEqual(distance, 1386, accuracy: 1)
	}
}
