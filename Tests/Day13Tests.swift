import XCTest

@testable import AdventOfCode

final class Day13Tests: XCTestCase {
    let testData = """
    .####..
    ###..#.
    ..#.###
    #.####.
    #.####.
    ..#.###
    ###..#.
    .####..
    .....#.
    ...#.#.
    .####..
    ###..#.
    ..#.###
    """.data(using: .utf8)!

    func testPart1() async throws {
        XCTAssertEqual(try Day13(data: testData).part1() as! Int, 400)
    }

    func testPart2() async throws {
        XCTAssertEqual(try Day13(data: testData).part2() as! Int, 900)
    }
}
