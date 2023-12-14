import XCTest

@testable import AdventOfCode

final class Day14Tests: XCTestCase {
    let testData = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """.data(using: .utf8)!

    func testPart1() async throws {
        XCTAssertEqual(try Day14(data: testData).part1() as! Int, 136)
    }

    func testPart2() async throws {
        XCTAssertEqual(try Day14(data: testData).part2() as! Int, 64)
    }
}
