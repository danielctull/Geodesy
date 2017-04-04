
import XCTest
import Geodesy

class CoordinateDirectionsTests: XCTestCase {

	func testHeading() {
		let coordinate1 = Coordinate(latitude: 50.887205, longitude: -0.66426516)
		let coordinate2 = Coordinate(latitude: 50.894487, longitude: -0.64822286)
		let heading = coordinate1.initialHeading(to: coordinate2)
		XCTAssertEqualWithAccuracy(heading, 54.255, accuracy: 1e-4)
	}

	func testDistance() {
		let coordinate1 = Coordinate(latitude: 50.887205, longitude: -0.66426516)
		let coordinate2 = Coordinate(latitude: 50.894487, longitude: -0.64822286)
		let distance = coordinate1.distance(to: coordinate2)
		XCTAssertEqualWithAccuracy(distance, 1386, accuracy: 1)
	}
}
