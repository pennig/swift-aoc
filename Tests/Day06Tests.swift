import XCTest

@testable import AdventOfCode

final class Day06Tests: XCTestCase {
    let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """.data(using: .utf8)!

    func testPart1() throws {
        XCTAssertEqual(try Day06(data: testData).part1() as! Int, 288)
    }

    func testPart2() throws {
        XCTAssertEqual(try Day06(data: testData).part2() as! Int, 71503)
    }
}
