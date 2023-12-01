import Algorithms
import Foundation

struct Day01: AdventDay {
    var data: Data

    init(data: Data) {
        self.data = data
    }

    var elfCalories: [[Int]] {
        data.stringGroups().map {
            $0.compactMap({ Int($0) })
        }
    }

    func part1() -> Any {
        let totals = elfCalories.map { $0.reduce(0, +) }
        return totals.max(count: 1).reduce(0, +)
    }

    func part2() -> Any {
        let totals = elfCalories.map { $0.reduce(0, +) }
        return totals.max(count: 3).reduce(0, +)
    }
}
