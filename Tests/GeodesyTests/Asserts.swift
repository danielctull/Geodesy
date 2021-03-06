
import XCTest

public func AssertEqual(_ int1: Int?, _ int2: Int?, accuracy: Int?, file: StaticString = #file, line: UInt = #line) {

    guard let i1 = int1, let i2 = int2 else {
        XCTAssertEqual(int1, int2, file: file, line: line)
        return
    }

    let a = accuracy ?? 0
    XCTAssert(i1 < i2 + a, file: file, line: line)
    XCTAssert(i1 > i2 - a, file: file, line: line)
}
