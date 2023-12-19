import XCTest

@testable import AdventOfCode

final class Day18Tests: XCTestCase {
    let testData = """
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    """.data(using: .utf8)!

    func testPart1() async throws {
        XCTAssertEqual(try Day18(data: testData).part1() as! Int, 62)
    }

    func testPart2() async throws {
        XCTAssertEqual(try Day18(data: testData).part2() as! Int, 952408144115)
    }
}

