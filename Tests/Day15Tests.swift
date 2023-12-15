import XCTest

@testable import AdventOfCode

final class Day15Tests: XCTestCase {
    let testData = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7

    """.data(using: .utf8)!

    func testPart1() async throws {
        XCTAssertEqual(try Day15(data: testData).part1() as! UInt, 1320)
    }

    func testPart2() async throws {
        XCTAssertEqual(try Day15(data: testData).part2() as! Int, 145)
    }
}
