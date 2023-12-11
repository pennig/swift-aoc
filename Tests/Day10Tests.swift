import Algorithms
import XCTest

@testable import AdventOfCode

final class Day10Tests: XCTestCase {
    func testPart2() throws {
        let testData = """
        ...........
        .F-------7.
        .SF-----7|.
        .||.....||.
        .||.....||.
        .|L-7.F-J|.
        .|..|.|..|.
        .L--J.L--J.
        ...........
        """.data(using: .utf8)!
        let alternateTestData = """
        FF7F7F7F7F7F7F7F---7
        L|LJS|||||||||||F--J
        FL-7LJLJ||||||LJL-77
        F--JF--7||LJLJIF7FJ-
        L---JF-JLJIIIIFJLJJ7
        |F|F-JF---7IIIL7L|7|
        |FFJF7L7F-JF7IIL---7
        7-L-JL7||F7|L7F-7F7|
        L.L7LFJ|||||FJL7||LJ
        L7JLJL-JLJLJL--JLJ.L
        """.data(using: .utf8)!

        let day = Day10(data: testData)
        XCTAssertEqual(try day.part2() as! Int, 4)
        let day2 = Day10(data: alternateTestData)
        XCTAssertEqual(try day2.part2() as! Int, 10)
    }
}
