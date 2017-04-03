
import XCTest
import Geodesy

class CoordinateConversionTests: XCTestCase {

	func testWGS84toWGS84() {
		let wgs84 = Coordinate(latitude: 52.657977, longitude: 1.716038, system: .wgs84)
		let new = wgs84.convert(to: .wgs84)
		XCTAssertEqualWithAccuracy(new.latitude, 52.657977, accuracy: 1e-6)
		XCTAssertEqualWithAccuracy(new.longitude, 1.716038, accuracy: 1e-6)
	}

	func testOSGB36toOSGB36() {
		let osgb36 = Coordinate(latitude: 52.657568, longitude: 1.717908, system: .osgb36)
		let new = osgb36.convert(to: .osgb36)
		XCTAssertEqualWithAccuracy(new.latitude, 52.657568, accuracy: 1e-6)
		XCTAssertEqualWithAccuracy(new.longitude, 1.717908, accuracy: 1e-6)
	}

	func testWGS84toOSGB36() {
		let wgs84 = Coordinate(latitude: 52.657977, longitude: 1.716038, system: .wgs84)
		let osgb36 = wgs84.convert(to: .osgb36)
		XCTAssertEqualWithAccuracy(osgb36.latitude, 52.657568, accuracy: 1e-6)
		XCTAssertEqualWithAccuracy(osgb36.longitude, 1.717908, accuracy: 1e-6)
	}

	func testOSGB36toWGS84() {
		let osgb36 = Coordinate(latitude: 52.657568, longitude: 1.717908, system: .osgb36)
		let wgs84 = osgb36.convert(to: .wgs84)
		XCTAssertEqualWithAccuracy(wgs84.latitude, 52.657977, accuracy: 1e-6)
		XCTAssertEqualWithAccuracy(wgs84.longitude, 1.716038, accuracy: 1e-6)
	}
}
