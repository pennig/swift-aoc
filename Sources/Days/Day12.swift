import Algorithms
import Foundation
import Parsing

struct Day12: AdventDay {
    var data: Data

    func part1() async throws -> Any {
        let rows = try data.parseLines(Day12.parser())
        return await withTaskGroup(of: Int.self) { group in
            for row in rows {
                group.addTask { row.possibilities() }
            }
            return await group.reduce(0, +)
        }
    }

    func part2() async throws -> Any {
        let rows = try data.parseLines(Day12.parser())
        return await withTaskGroup(of: Int.self) { group in
            for row in rows {
                group.addTask { row.evenMorePossibilities() }
            }
            return await group.reduce(0, +)
        }
    }

    class Row {
        var conditions: [Condition]
        var groups: [Int]

        init(conditions: [Condition], groups: [Int]) {
            self.conditions = conditions
            self.groups = groups
        }

        private var cache: [Cursor: Int] = [:]
        struct Cursor: Hashable {
            let condition: Int
            let group: Int
            let accumulator: Int
        }

        func possibilities() -> Int {
            cache = [:]; defer { cache = [:] }
            return possibilities(conditions: conditions[...], groups: groups[...], groupAccumulator: 0)
        }

        func evenMorePossibilities() -> Int {
            cache = [:]; defer { cache = [:] }
            let conditions = Array([conditions, conditions, conditions, conditions, conditions].joined(by: .unknown))
            let groups = groups + groups + groups + groups + groups
            return possibilities(conditions: conditions[...], groups: groups[...], groupAccumulator: 0)
        }

        private func possibilities(conditions: [Condition].SubSequence, groups: [Int].SubSequence, groupAccumulator: Int) -> Int {
            let cursor = Cursor(condition: conditions.indices.first ?? -1, group: groups.indices.first ?? -1, accumulator: groupAccumulator)
            if cursor.condition >= 0, cursor.group >= 0, let cachedValue = cache[cursor] {
                return cachedValue
            }

            guard let c = conditions.first else {
                if groups.isEmpty {
                    // Reached end with no in-progress group
                    return groupAccumulator == 0 ? 1 : 0
                } else if groups.count == 1, let g = groups.first {
                    // Reached end with the final group fulfilled
                    return groupAccumulator == g ? 1 : 0
                } else {
                    // Reached end with in-progress groups. Not a possibility!
                    return 0
                }
            }

            var out = 0
            switch c {
            case .unknown:
                // assume .damaged
                out += tryDamaged(conditions: conditions, groups: groups, groupAccumulator: groupAccumulator)
                // assume .operational
                out += tryOperational(conditions: conditions, groups: groups, groupAccumulator: groupAccumulator)
            case .damaged:
                out += tryDamaged(conditions: conditions, groups: groups, groupAccumulator: groupAccumulator)
            case .operational:
                out += tryOperational(conditions: conditions, groups: groups, groupAccumulator: groupAccumulator)
            }

            cache[cursor] = out
            return out
        }

        private func tryDamaged(conditions: [Condition].SubSequence, groups: [Int].SubSequence, groupAccumulator: Int) -> Int {
            // Group overrun
            guard let g = groups.first, groupAccumulator < g else { return 0 }
            // Continuing a group
            return possibilities(conditions: conditions.dropFirst(), groups: groups, groupAccumulator: groupAccumulator + 1)
        }

        private func tryOperational(conditions: [Condition].SubSequence, groups: [Int].SubSequence, groupAccumulator: Int) -> Int {
            if groupAccumulator > 0 {
                // Reached end of group prematurely
                guard let g = groups.first, groupAccumulator == g else { return 0 }
                // End of a group in progress
                return possibilities(conditions: conditions.dropFirst(), groups: groups.dropFirst(), groupAccumulator: 0)
            } else {
                return possibilities(conditions: conditions.dropFirst(), groups: groups, groupAccumulator: 0)
            }
        }
    }

    enum Condition: Equatable {
        case unknown
        case operational
        case damaged
    }

    static func parser() -> any Parser<Substring.UTF8View, Row> {
        Parse(input: Substring.UTF8View.self) {
            Many {
                OneOf {
                    "?".utf8.map { Condition.unknown }
                    ".".utf8.map { Condition.operational }
                    "#".utf8.map { Condition.damaged }
                }
            }
            " ".utf8
            Many { Int.parser() } separator: { ",".utf8 }
        }.map(Row.init)
    }
}
