import XCTest

@testable import AdventOfCode

final class Day09Tests: XCTestCase {
    func testNextInteger() throws {
        XCTAssertEqual([0, 3, 6, 9, 12, 15].nextInteger(), 18)
        XCTAssertEqual([1, 3, 6, 10, 15, 21].nextInteger(), 28)
        XCTAssertEqual([10, 13, 16, 21, 30, 45].nextInteger(), 68)
    }
}
