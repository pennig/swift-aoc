import Algorithms
import Foundation

struct Day09: AdventDay {
    var data: Data

    func part1() throws -> Any {
        return data.strings().map(\.numbers).map(\.nextInteger).reduce(0, +)
    }

    func part2() throws -> Any {
        return data.strings().map(\.numbers).map({ $0.reversed() }).map(\.nextInteger).reduce(0, +)
    }
}

extension BidirectionalCollection where Element == Int {
    var nextInteger: Int {
        let dx = self.adjacentPairs().map { $1 - $0 }
        let set = Set(dx)
        if set.count == 1 && set.first == 0 {
            return last!
        } else {
            return last! + dx.nextInteger
        }
    }
}
