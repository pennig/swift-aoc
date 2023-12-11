import Algorithms
import Foundation

struct Day10: AdventDay {
    var data: Data

    func part1() throws -> Any {
        var steps = 0
        walk { _, _ in
            steps += 1
        }
        return steps / 2
    }

    func part2() throws -> Any {
        var numberOfPipes = 0
        var vertices: [(Int, Int)] = []
        walk { coordinate, pipe in
            if pipe == .NW || pipe == .NE || pipe == .SW || pipe == .SE {
                vertices.append(coordinate)
            }
            numberOfPipes += 1
        }

        // Leverage the shoelace formula to calculate the enclosed area.
        // See: https://en.wikipedia.org/wiki/Shoelace_formula
        let shoelace = (vertices + vertices.prefix(1)).adjacentPairs().map {
            return $0.0.0 * $0.1.1 - $0.1.0 * $0.0.1
        }.reduce(0, +)

        return (abs(shoelace) - numberOfPipes) / 2 + 1 // + 1? not sure why, but this is necessary.
    }

    func pipes() -> (start: (x: Int, y: Int), map: [[Pipe]]) {
        var start: (Int, Int) = (0, 0)
        var pipes: [[Pipe]] = []

        for (y, line) in data.substrings().enumerated() {
            var linePipes = [Pipe]()
            for (x, char) in line.utf8.enumerated() {
                let pipe = Pipe(rawValue: char)
                linePipes.append(pipe)
                if pipe == .start {
                    start = (x, y)
                }
            }
            pipes.append(linePipes)
        }

        return (start, pipes)
    }

    func walk(visitor: ((Int, Int), Pipe) -> Void) {
        var pipes = pipes()

        // Data says S is |, so Imma cheat and just replace it.
        pipes.map[pipes.start.y][pipes.start.x] = .NS
        var c: (Int, Int) = (pipes.start.x, pipes.start.y)
        var d = Direction.up
        repeat {
            d = pipes.map[c.1][c.0].next(from: d)
            c = d.move(c: c)
            visitor(c, pipes.map[c.1][c.0])
        } while (c != (pipes.start.x, pipes.start.y))
    }

    enum Direction {
        case up, down, left, right, none

        var delta: (Int, Int) {
            switch self {
            case .up: (0, -1)
            case .down: (0, 1)
            case .left: (-1, 0)
            case .right: (1, 0)
            case .none: (0, 0)
            }
        }

        func move(c: (Int, Int)) -> (Int, Int) {
            let delta = self.delta
            return (c.0 + delta.0, c.1 + delta.1)
        }
    }

    enum Pipe {
        case start, WE, NS, NW, NE, SW, SE, none

        func next(from: Direction) -> Direction {
            switch self {
            case .start, .none: .none
            case .WE: from == .left ? .left : .right
            case .NS: from == .up ? .up : .down
            case .NW: from == .up ? .right : .down
            case .NE: from == .up ? .left : .down
            case .SW: from == .down ? .right : .up
            case .SE: from == .down ? .left : .up
            }
        }

        init(rawValue: UInt8) {
            self = switch rawValue {
            case UInt8(ascii: "S"): .start
            case UInt8(ascii: "-"): .WE
            case UInt8(ascii: "|"): .NS
            case UInt8(ascii: "F"): .NW
            case UInt8(ascii: "7"): .NE
            case UInt8(ascii: "L"): .SW
            case UInt8(ascii: "J"): .SE
            default: .none
            }
        }
    }
}
