import Collections
import Foundation

struct Day16: AdventDay {
    var data: Data

    func field() -> Field {
        Field(mirrors: data.substrings().map { $0.utf8.map(Mirror.init(rawValue:)) })
    }

    func part1() throws -> Any {
        field().activationCount(from: .init(coordinate: .init(0, 0), moving: .right))
    }

    func part2() throws -> Any {
        let field = self.field()
        let width = field.mirrors[0].indices.last!
        let height = field.mirrors.indices.last!
        var locations = [Location]()

        for y in (0...height) {
            locations.append(.init(coordinate: .init(0, y), moving: .right))
            locations.append(.init(coordinate: .init(width, y), moving: .left))
        }
        for x in (0...width) {
            locations.append(.init(coordinate: .init(x, 0), moving: .down))
            locations.append(.init(coordinate: .init(x, height), moving: .up))
        }

        return locations.reduce(0) {
            max($0, field.activationCount(from: $1))
        }
    }

    class Field {
        let mirrors: [[Mirror]]
        private(set) lazy var hIndices = mirrors[0].indices
        private(set) lazy var vIndices = mirrors.indices

        init(mirrors: [[Mirror]]) {
            self.mirrors = mirrors
        }

        func activationCount(from: Location) -> Int {
            return activatedCoordinates(from: from).filter { $0 > 0 }.count
        }

        private func activatedCoordinates(from: Location) -> [UInt8] {
            var input = Deque<Location>()
            var output = [UInt8](repeating: 0, count: hIndices.count * vIndices.count)
            input.append(from)

            while let current = input.popFirst() {
                guard hIndices.contains(current.coordinate.x) && vIndices.contains(current.coordinate.y) else {
                    continue
                }

                let index = current.coordinate.x*(vIndices.count)+current.coordinate.y
                if output[index] & current.moving.rawValue != 0 {
                    // We've been here before.
                    // But, unlike light, we cannot span the infinite.
                    continue
                }
                output[index] |= current.moving.rawValue

                let mirror = mirrors[current.coordinate.y][current.coordinate.x]
                let newDirections = mirror.direction(moving: current.moving)
                for d in newDirections {
                    input.append(.init(coordinate: d.next(current.coordinate), moving: d))
                }
            }
            return output
        }
    }

    struct Location: Hashable {
        let coordinate: Coordinate
        let moving: Direction
    }

    struct Coordinate: Hashable {
        let x, y: Int
        init(_ x: Int, _ y: Int) { self.x = x; self.y = y }
    }

    enum Direction: UInt8, Hashable {
        case up = 1, down = 2, left = 4, right = 8

        func next(_ coordinate: Coordinate) -> Coordinate {
            switch self {
            case .up: .init(coordinate.x, coordinate.y - 1)
            case .down: .init(coordinate.x, coordinate.y + 1)
            case .left: .init(coordinate.x - 1, coordinate.y)
            case .right: .init(coordinate.x + 1, coordinate.y)
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
        
        private static let leftDestination = [Direction.left]
        private static let rightDestination = [Direction.right]
        private static let upDestination = [Direction.up]
        private static let downDestination = [Direction.down]
        private static let upDownDestinations = [Direction.up, Direction.down]
        private static let leftRightDestinations = [Direction.left, Direction.right]

        func direction(moving prev: Direction) -> [Direction] {
            switch self {
            case .none:
                return switch prev {
                case .up: Self.upDestination
                case .down: Self.downDestination
                case .left: Self.leftDestination
                case .right: Self.rightDestination
                }
            case .left:
                return switch prev {
                case .up: Self.leftDestination
                case .down: Self.rightDestination
                case .left: Self.upDestination
                case .right: Self.downDestination
                }
            case .right:
                return switch prev {
                case .up: Self.rightDestination
                case .down: Self.leftDestination
                case .left: Self.downDestination
                case .right: Self.upDestination
                }
            case .vertical:
                return switch prev {
                case .up: Self.upDestination
                case .down: Self.downDestination
                case .left, .right: Self.upDownDestinations
                }
            case .horizontal:
                return switch prev {
                case .up, .down: Self.leftRightDestinations
                case .left: Self.leftDestination
                case .right: Self.rightDestination
                }
            }
        }
    }
}
