
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
}
