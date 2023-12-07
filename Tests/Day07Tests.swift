import XCTest

@testable import AdventOfCode

final class Day07Tests: XCTestCase {
    let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """.data(using: .utf8)!

    func testHand() throws {
        var hand = "32T3K 765"[...].utf8
        let out = try Day07.parser(jokers: false).parse(&hand)
        XCTAssertEqual(out.cards, [3, 2, 10, 3, 13])
        XCTAssertEqual(out.bid, 765)
        XCTAssertEqual(out.strength, 1)
    }

    func testPart1() throws {
        XCTAssertEqual(try Day07(data: testData).part1() as! Int, 6440)
    }

    func testPart2() throws {
        XCTAssertEqual(try Day07(data: testData).part2() as! Int, 5905)
    }
}
