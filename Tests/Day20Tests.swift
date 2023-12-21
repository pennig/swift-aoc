import XCTest

@testable import AdventOfCode

final class Day20Tests: XCTestCase {
    let testData = """
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
    """.data(using: .utf8)!

    let testData2 = """
    broadcaster -> a
    %a -> inv, con
    &inv -> b
    %b -> con
    &con -> output
    """.data(using: .utf8)!

    func testPart1() async throws {
        XCTAssertEqual(try Day20(data: testData).part1() as! Int, 32000000)
        XCTAssertEqual(try Day20(data: testData2).part1() as! Int, 11687500)
    }

    func testPart2() async throws {
        XCTAssertEqual(try Day20(data: testData).part2() as! Int, 0)
    }
}

