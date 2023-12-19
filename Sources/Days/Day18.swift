import Algorithms
import Foundation
import Parsing

struct Day18: AdventDay {
    var data: Data

    func part1() throws -> Any {
        try area(parser: Parse(input: Substring.UTF8View.self) {
            OneOf {
                "U".utf8.map { Direction.up }
                "D".utf8.map { Direction.down }
                "R".utf8.map { Direction.right }
                "L".utf8.map { Direction.left }
            }
            " ".utf8
            Int.parser()
        }.map(Step.init))
    }

    func part2() throws -> Any {
        try area(parser: Parse(input: Substring.UTF8View.self) {
            Skip { PrefixThrough("#".utf8) }
            Prefix(5).pipe { Int.parser(radix: 16) }
            OneOf {
                "0".utf8.map { Direction.right }
                "1".utf8.map { Direction.down }
                "2".utf8.map { Direction.left }
                "3".utf8.map { Direction.up }
            }
        }.map { Step(direction: $0.1, distance: $0.0) })
    }

    func area(parser: any Parser<Substring.UTF8View, Step>) throws -> Int {
        var current = Coordinate(0, 0)
        var distance = 0
        let vertices = try data.parseLines(parser).map {
            let next = current.move($0.distance, inDirection: $0.direction)
            current = next
            distance += $0.distance

            return next
        }

        // It's day 10 all over again!
        let shoelace = (vertices + vertices.prefix(1)).adjacentPairs().map {
            return $0.0.x * $0.1.y - $0.1.x * $0.0.y
        }.reduce(0, +)

        return (shoelace + distance) / 2 + 1
    }

    struct Coordinate: Hashable {
        let x, y: Int
        init(_ x: Int, _ y: Int) { self.x = x; self.y = y }

        func move(_ distance: Int, inDirection direction: Direction) -> Coordinate {
            switch direction {
            case .up: .init(x, y - distance)
            case .down: .init(x, y + distance)
            case .left: .init(x - distance, y)
            case .right: .init(x + distance, y)
            }
        }
    }

    enum Direction {
        case up, down, left, right
    }
    struct Step {
        let direction: Direction, distance: Int
    }
}
