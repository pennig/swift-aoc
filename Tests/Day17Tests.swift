import XCTest

@testable import AdventOfCode

final class Day17Tests: XCTestCase {
    let testData = #"""
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
    """#.data(using: .utf8)!

    func testPart1() async throws {
        XCTAssertEqual(try Day17(data: testData).part1() as! Int, 102)
    }

    func testPart2() async throws {
        XCTAssertEqual(try Day17(data: testData).part2() as! Int, 94)
    }

    func testAlternatePart2() async throws {
        let testData = #"""
        111111111111
        999999999991
        999999999991
        999999999991
        999999999991
        """#.data(using: .utf8)!
        XCTAssertEqual(try Day17(data: testData).part2() as! Int, 71)
    }
}
