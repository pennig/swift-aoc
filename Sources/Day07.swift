import Foundation
import Parsing

struct Day07: AdventDay {
    var data: Data

    func part1() throws -> Any {
        try winnings(jokers: false)
    }

    func part2() throws -> Any {
        try winnings(jokers: true)
    }

    func winnings(jokers: Bool) throws -> Int {
        let hands = try data.substrings().map { var line = $0.utf8; return try Day07.parser(jokers: jokers).parse(&line) }
        return hands
            .sorted(by: <)
            .enumerated()
            .reduce(0) { $0 + $1.element.bid * ($1.offset+1)}
    }

    struct Hand: Comparable {
        let cards: [UInt8]
        let bid: Int
        let strength: UInt8

        init(cards: [UInt8], bid: Int) {
            self.cards = cards
            self.bid = bid
            strength = Self.strength(cards)
        }

        static func strength(_ cards: [UInt8]) -> UInt8 {
            var jokers:UInt8 = 0
            let scores = cards.reduce(into: [UInt8: UInt8]()) {
                if $1 == 1 {
                    jokers += 1
                } else {
                    $0[$1] = $0[$1, default: 0] + 1
                }
            }.values.sorted(by: >)

            if jokers == 5 {
                return 6 // what a bunch of jokers
            } else if scores[0] + jokers == 5 {
                return 6 // five of a kind
            } else if scores[0] + jokers == 4 {
                return 5 // four of a kind
            } else if scores[0] + jokers == 3 {
                if scores[1] == 2 {
                    return 4 // full house
                } else {
                    return 3 // three of a kind
                }
            } else if scores[0] + jokers == 2 {
                if scores[1] == 2 {
                    return 2 // two pair
                } else {
                    return 1 // one pair
                }
            } else {
                return 0 // high card
            }
        }

        static func < (lhs: Hand, rhs: Hand) -> Bool {
            if lhs.strength != rhs.strength { return lhs.strength < rhs.strength }
            for pair in zip(lhs.cards, rhs.cards) {
                if pair.0 < pair.1 { return true }
                if pair.0 > pair.1 { return false }
            }
            return false
        }
    }

    static func parser(jokers: Bool) -> any Parser<Substring.UTF8View, Hand> {
        Parse(input: Substring.UTF8View.self) {
            Many(5) {
                OneOf {
                    Prefix(1) { (UInt8(ascii: "2")...UInt8(ascii: "9")).contains($0) }.map { $0.first! - 48 }
                    "T".utf8.map { 0xa as UInt8 }
                    "J".utf8.map { (jokers ? 1 : 0xb) as UInt8 }
                    "Q".utf8.map { 0xc as UInt8 }
                    "K".utf8.map { 0xd as UInt8 }
                    "A".utf8.map { 0xe as UInt8 }
                }
            }
            " ".utf8
            Int.parser()
        }.map(Hand.init)
    }
}
