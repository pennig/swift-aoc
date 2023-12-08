import XCTest

@testable import AdventOfCode

final class Day08Tests: XCTestCase {
    func testPart1() throws {
        let shortPath = """
        RL

        AAA = (BBB, CCC)
        BBB = (DDD, EEE)
        CCC = (ZZZ, GGG)
        DDD = (DDD, DDD)
        EEE = (EEE, EEE)
        GGG = (GGG, GGG)
        ZZZ = (ZZZ, ZZZ)
        """.data(using: .utf8)!
        XCTAssertEqual(try Day08(data: shortPath).part1() as! Int, 2)

        let longerPath = """
        LLR

        AAA = (BBB, BBB)
        BBB = (AAA, ZZZ)
        ZZZ = (ZZZ, ZZZ)
        """.data(using: .utf8)!
        XCTAssertEqual(try Day08(data: longerPath).part1() as! Int, 6)
    }

    func testPart2() throws {
        let ghostlyPath = """
        LR

        11A = (11B, XXX)
        11B = (XXX, 11Z)
        11Z = (11B, XXX)
        22A = (22B, XXX)
        22B = (22C, 22C)
        22C = (22Z, 22Z)
        22Z = (22B, 22B)
        XXX = (XXX, XXX)
        """.data(using: .utf8)!
        XCTAssertEqual(try Day08(data: ghostlyPath).part2() as! Int, 6)
    }
}
