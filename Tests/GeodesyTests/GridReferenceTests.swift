
import Geodesy
import XCTest

final class GridReferenceTests: XCTestCase {

	func testNumberOfFigures() {
		let reference = OSGridReference(reference: "SU 95166 11426")
		let easting = reference?.easting(withNumberOfFigures: 4)
		let northing = reference?.northing(withNumberOfFigures: 3)
		XCTAssertEqual(easting, "9517")
		XCTAssertEqual(northing, "114")
	}

	func testNumberOfFiguresTooMany() {
		let reference = OSGridReference(reference: "SU 95166 11426")
		let easting = reference?.easting(withNumberOfFigures: 10)
		let northing = reference?.northing(withNumberOfFigures: 10)
		XCTAssertNil(easting)
		XCTAssertNil(northing)
	}

	func testNumberOfFiguresMax() {
		let reference = OSGridReference(reference: "SU 95166 11426")
		let easting = reference?.easting(withNumberOfFigures: 5)
		let northing = reference?.northing(withNumberOfFigures: 5)
		XCTAssertEqual(easting, "95166")
		XCTAssertEqual(northing, "11426")
	}

	func testNumberOfFiguresMoreThanGiven() {
		let reference = OSGridReference(reference: "SU 9516 1142")
		let easting = reference?.easting(withNumberOfFigures: 5)
		let northing = reference?.northing(withNumberOfFigures: 5)
		XCTAssertEqual(easting, "95165")
		XCTAssertEqual(northing, "11425")
	}
}
