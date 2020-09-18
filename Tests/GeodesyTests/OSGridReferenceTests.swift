
import Geodesy
import XCTest

final class OSGridReferenceTests: XCTestCase {
    
    func testInitCoordinateOSGB36() {
        let coordinate = Coordinate(latitude: 52.657568, longitude: 1.717908, system: .osgb36)
        let reference = OSGridReference(coordinate: coordinate)
        XCTAssertEqual(reference?.easting, 651408)
        XCTAssertEqual(reference?.northing, 313176)
        XCTAssertEqual(reference?.region, "TG")
    }
    
    func testInitCoordinateWGS84() {
        let coordinate = Coordinate(latitude: 52.657968, longitude: 1.7160229, system: .wgs84)
        let reference = OSGridReference(coordinate: coordinate)
        XCTAssertEqual(reference?.accuracy, 5)
        AssertEqual(reference?.easting, 651408, accuracy: reference?.accuracy)
        AssertEqual(reference?.northing, 313176, accuracy: reference?.accuracy)
        XCTAssertEqual(reference?.region, "TG")
    }
    
    func testInitReference1() {
        let reference = OSGridReference(reference: "TG51")
        XCTAssertEqual(reference?.region, "TG")
        XCTAssertEqual(reference?.easting, 655000)
        XCTAssertEqual(reference?.northing, 315000)
    }
    
    func testInitReference2() {
        let reference = OSGridReference(reference: "SU951114")
        XCTAssertEqual(reference?.region, "SU")
        XCTAssertEqual(reference?.easting, 495150)
        XCTAssertEqual(reference?.northing, 111450)
    }
    
    func testInitReferenceEmpty() {
        let reference = OSGridReference(reference: "")
        XCTAssertNil(reference)
    }
    
    func testInitReferenceOddValue() {
        let reference = OSGridReference(reference: "TG123")
        XCTAssertNil(reference)
    }
    
    func testInitReferenceEastingLowerOutOfBounds() {
        let reference = OSGridReference(reference: "RZ99")
        XCTAssertNil(reference)
    }
    
    func testInitReferenceNorthingLowerOutOfBounds() {
        let reference = OSGridReference(reference: "XA00")
        XCTAssertNil(reference)
    }
    
    func testInitReferenceEastingUpperOutOfBounds() {
        let reference = OSGridReference(reference: "TX00")
        XCTAssertNil(reference)
    }
    
    func testInitReferenceNorthingUpperOutOfBounds() {
        let reference = OSGridReference(reference: "HK00")
        XCTAssertNil(reference)
    }
    
    func testCoordinate() throws {
        let reference = OSGridReference(reference: "SU 95166 11426")
        let coordinate = try XCTUnwrap(reference?.coordinate)
        XCTAssertEqual(coordinate.latitude.degrees, 50.894487, accuracy: 0.01)
        XCTAssertEqual(coordinate.longitude.degrees, -0.64822286, accuracy: 0.01)
    }
}
