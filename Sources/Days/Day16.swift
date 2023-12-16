import Foundation

struct Day16: AdventDay {
    var data: Data

    func part1() throws -> Any {
        var locations = locations()
        walk(&locations)
        return locations.reduce(0) {
            $0 + $1.map({ $0.visits.isEmpty ? 0 : 1 }).reduce(0, +)
        }
    }

    func part2() throws -> Any {
        var maxScore = 0
        let original = locations()
        for y in original.indices {
            var locations = original
            walk(&locations, start: (0, y), moving: .right)
            let score = locations.reduce(0) {
                $0 + $1.map({ $0.visits.isEmpty ? 0 : 1 }).reduce(0, +)
            }
            maxScore = max(maxScore, score)
        }
        for y in original.indices {
            var locations = original
            walk(&locations, start: (original[0].count-1, y), moving: .left)
            let score = locations.reduce(0) {
                $0 + $1.map({ $0.visits.isEmpty ? 0 : 1 }).reduce(0, +)
            }
            maxScore = max(maxScore, score)
        }
        for x in original[0].indices {
            var locations = original
            walk(&locations, start: (x, 0), moving: .down)
            let score = locations.reduce(0) {
                $0 + $1.map({ $0.visits.isEmpty ? 0 : 1 }).reduce(0, +)
            }
            maxScore = max(maxScore, score)
        }
        for x in original.indices {
            var locations = original
            walk(&locations, start: (x, original.count-1), moving: .up)
            let score = locations.reduce(0) {
                $0 + $1.map({ $0.visits.isEmpty ? 0 : 1 }).reduce(0, +)
            }
            maxScore = max(maxScore, score)
        }

        return maxScore
    }

    func walk(_ grid: inout [[Location]], start: (Int, Int) = (0, 0), moving: Direction = .right) {
        let vIndices = grid.indices
        let hIndices = grid[0].indices

        var current = start
        var moving = moving
        while hIndices.contains(current.0) && vIndices.contains(current.1) {
            if grid[current.1][current.0].visits.contains(moving) {
                // We've been here before.
                // Unlike light, we cannot span the infinite.
                return
            }

            grid[current.1][current.0].visits.insert(moving)
            let to = grid[current.1][current.0].mirror.direction(moving: moving)
            for d in to.dropFirst() {
                let next = d.next
                let start = (current.0 + next.0, current.1 + next.1)
                walk(&grid, start: start, moving: d)
            }
            moving = to[0]
            let next = moving.next
            current = (current.0 + next.0, current.1 + next.1)
        }
    }

    func locations() -> [[Location]] {
        data.substrings().map {
            $0.utf8.map {
                Location(mirror: Mirror.init(rawValue: $0))
            }
        }
    }

    struct Start {
        let x: Int
        let y: Int
        let moving: Direction
    }

    struct Location {
        let mirror: Mirror
        var visits = Set<Direction>()
    }

    enum Direction {
        case up, down, left, right

        var next: (Int, Int) {
            switch self {
            case .up: (0, -1)
            case .down: (0, 1)
            case .left: (-1, 0)
            case .right: (1, 0)
            }
        }
    }

    enum Mirror {
        case none, left, right, vertical, horizontal

        init(rawValue: UInt8) {
            self = switch rawValue {
            case UInt8(ascii: "-"): .horizontal
            case UInt8(ascii: "|"): .vertical
            case UInt8(ascii: "\\"): .left
            case UInt8(ascii: "/"): .right
            default: .none
            }
        }

        func direction(moving prev: Direction) -> [Direction] {
            switch self {
            case .none:
                 return [prev]
            case .left:
                return switch prev {
                case .up: [.left]
                case .down: [.right]
                case .left: [.up]
                case .right: [.down]
                }
            case .right:
                return switch prev {
                case .up: [.right]
                case .down: [.left]
                case .left: [.down]
                case .right: [.up]
                }
            case .vertical:
                return switch prev {
                case .up, .down: [prev]
                case .left, .right: [.up, .down]
                }
            case .horizontal:
                return switch prev {
                case .up, .down: [.left, .right]
                case .left, .right: [prev]
                }
            }
        }
    }
}
