import Algorithms
import Foundation

struct Day11: AdventDay {
    var data: Data

    func part1() throws -> Any {
        let expanded = space().expand(factor: 2)
        return sumOfLengths(expanded)
    }

    func part2() throws -> Any {
        let expanded = space().expand(factor: 1_000_000)
        return sumOfLengths(expanded)
    }

    struct Space {
        var emptyRows: Set<Int>
        var emptyColumns: Set<Int>
        var points: [(Int, Int)]

        func expand(factor: Int) -> [(Int, Int)] {
            points.map { point in
                (
                    point.0 + emptyColumns.filter({ point.0 > $0 }).count * (factor-1),
                    point.1 + emptyRows.filter({ point.1 > $0 }).count * (factor-1)
                )
            }
        }
    }

    func space() -> Space {
        var occupiedRows = Set<Int>()
        var occupiedColumns = Set<Int>()
        var points: [(Int, Int)] = []

        var lastX = 0, lastY = 0
        for (y, line) in data.substrings().enumerated() {
            for (x, char) in line.utf8.enumerated() {
                if char == UInt8(ascii: "#") {
                    occupiedRows.insert(y)
                    occupiedColumns.insert(x)
                    points.append((x, y))
                }
                lastX = x
            }
            lastY = y
        }

        return Space(
            emptyRows: Set(0..<lastY).subtracting(occupiedRows),
            emptyColumns: Set(0..<lastX).subtracting(occupiedColumns),
            points: points
        )
    }

    func sumOfLengths(_ points: [(Int, Int)]) -> Int {
        return points.combinations(ofCount: 2).reduce(0) {
            $0 + abs($1.first!.0 - $1.last!.0) + abs($1.first!.1 - $1.last!.1)
        }
    }
}
