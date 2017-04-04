
import XCTest
import Geodesy

class GridReferenceTests: XCTestCase {

	func testInitCoordinate() {
		let coordinate = Coordinate(latitude: 52.657568, longitude: 1.717908, system: .osgb36)
		let reference = OSGridReference(coordinate: coordinate)
		XCTAssertEqual(reference?.easting, 651408)
		XCTAssertEqual(reference?.northing, 313176)
		XCTAssertEqual(reference?.gridSquareLetters, "TG")
	}

	func testInitReference() {
		let reference = OSGridReference(reference: "TG51")
		XCTAssertEqual(reference?.gridSquareLetters, "TG")
		XCTAssertEqual(reference?.easting, 655000)
		XCTAssertEqual(reference?.northing, 315000)
	}
}
