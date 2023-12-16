import XCTest

@testable import AdventOfCode

final class Day16Tests: XCTestCase {
    let testData = #"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """#.data(using: .utf8)!

    func testPart1() async throws {
        XCTAssertEqual(try Day16(data: testData).part1() as! Int, 46)
    }

    func testPart2() async throws {
        XCTAssertEqual(try Day16(data: testData).part2() as! Int, 51)
    }
}
