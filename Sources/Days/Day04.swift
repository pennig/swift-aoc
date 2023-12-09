import Foundation
import Parsing

struct Day04: AdventDay {
    var data: Data

    func part1() throws -> Any {
        return try data.utf8views().map {
            var line = $0
            let card = try Card.parser.parse(&line)
            return card.numbers.reduce(0) {
                guard card.winners.contains($1) else { return $0 }
                return $0 == 0 ? 1 : $0 * 2
            }
        }.reduce(0, +)
    }

    func part2() throws -> Any {
        /*
         Build up a table (in reverse order) of how many cards each card *adds* to the total number of cards we get. The trick is that a copy of a card also adds the copies of the cards *that* copy adds, and so on..
         Every card adds at least itself to the total, so given the simplest case of 5 cards (A-E)—all losers—we make no copies and end up with 5 cards.

         If A is a loser, card B wins once, and C–E are losers we create a copy of C. No other cards make copies. Therefore, the table entry for card B becomes 2; 1 for itself, plus the table entry of C–also 1.
         [
             A(wins 0): 1,
             B(wins 1): 2 (self + C),
             C(wins 0): 1 (self),
             D(wins 0): 1 (self),
             E(wins 0): 1 (self)
         ]
         We then add up all the table entries to get 6: 1 + 2 + 1 + 1 + 1

         If card B wins twice, and C wins once (A, D, and E are still losers) the table then looks like this:
         [
             A(wins 0): 1,
             B(wins 2): 4 (self + C + D),
             C(wins 1): 2 (self + D),
             D(wins 0): 1 (self),
             E(wins 0): 1 (self)
         ]
         This leaves us with 9: 1 + 4 + 2 + 1 +1

         This dynamic of adding self plus subsequent table values is why we calculate things in reverse.
         */
        var cardsMemo = [Int: Int]()
        for var line in data.utf8views().reversed() {
            let card = try Card.parser.parse(&line)
            let winners = card.numbers.intersection(card.winners).count
            cardsMemo[card.id] = (0...winners).reduce(1) { $0 + cardsMemo[card.id+$1, default: 0] }
        }

        return cardsMemo.values.reduce(0, +)
    }
}

struct Card {
    let id: Int
    let numbers: Set<Int>
    let winners: Set<Int>

    static let integerSet =  Many {
        Int.parser(of: Substring.UTF8View.self)
    } separator: {
        " ".utf8; Optionally { " ".utf8 }
    }.map { Set($0) }

    static let parser = Parse(input: Substring.UTF8View.self) {
        Parse {
            "Card".utf8; Many { " ".utf8 }
            Int.parser()
            ": ".utf8; Optionally { " ".utf8 }
        }.map { $0.1 }

        integerSet

        " | ".utf8; Skip { Optionally { " ".utf8 }}

        integerSet
    }.map(Card.init)
}
