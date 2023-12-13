import XCTest

@testable import AdventOfCode

final class Day12Tests: XCTestCase {
    let testData = """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """.data(using: .utf8)!

    func testPart1() async throws {
        let day = Day12(data: testData)
        let total = try await day.part1() as! Int
        XCTAssertEqual(total, 21)
    }

    func testPart2() async throws {
        let day = Day12(data: testData)
        let total = try await day.part2() as! Int
        XCTAssertEqual(total, 525152)
    }
}
