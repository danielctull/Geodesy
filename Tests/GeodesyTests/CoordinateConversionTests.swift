
import Geodesy
import XCTest

final class CoordinateConversionTests: XCTestCase {

	func testWGS84toWGS84() {
		let wgs84 = Coordinate(latitude: 52.657977, longitude: 1.716038, system: .wgs84)
		let new = wgs84.convert(to: .wgs84)
        XCTAssertEqual(new.latitude.degrees, 52.657977, accuracy: 1e-6)
		XCTAssertEqual(new.longitude.degrees, 1.716038, accuracy: 1e-6)
	}

	func testOSGB36toOSGB36() {
		let osgb36 = Coordinate(latitude: 52.657568, longitude: 1.717908, system: .osgb36)
		let new = osgb36.convert(to: .osgb36)
		XCTAssertEqual(new.latitude.degrees, 52.657568, accuracy: 1e-6)
		XCTAssertEqual(new.longitude.degrees, 1.717908, accuracy: 1e-6)
	}

	func testWGS84toOSGB36() {
		let wgs84 = Coordinate(latitude: 52.657977, longitude: 1.716038, system: .wgs84)
		let osgb36 = wgs84.convert(to: .osgb36)
		XCTAssertEqual(osgb36.latitude.degrees, 52.657568, accuracy: 1e-6)
		XCTAssertEqual(osgb36.longitude.degrees, 1.717908, accuracy: 1e-6)
	}

	func testOSGB36toWGS84() {
		let osgb36 = Coordinate(latitude: 52.657568, longitude: 1.717908, system: .osgb36)
		let wgs84 = osgb36.convert(to: .wgs84)
		XCTAssertEqual(wgs84.latitude.degrees, 52.657977, accuracy: 1e-6)
		XCTAssertEqual(wgs84.longitude.degrees, 1.716038, accuracy: 1e-6)
	}
}
