import Collections
import Foundation

struct Day17: AdventDay {
    var data: Data

    func field() -> Field {
        Field(heats: data.substrings().map { $0.utf8.map({ Int($0 - 48) }) })
    }

    func part1() throws -> Any {
        // 1195 with input data
        field().lowestHeatLoss(movementRequirements: (1...3))
    }

    func part2() throws -> Any {
        // 1347 with input data
        field().lowestHeatLoss(movementRequirements: (4...10))
    }

    class Field {
        let heats: [[Int]]
        private(set) lazy var hIndices = heats[0].indices
        private(set) lazy var vIndices = heats.indices
        private(set) lazy var end: Coordinate = .init(hIndices.count-1, vIndices.count-1)

        init(heats: [[Int]]) {
            self.heats = heats
        }

        func lowestHeatLoss(movementRequirements: ClosedRange<Int>) -> Int {
            var steps: Heap<Step> = [
                .init(location: .init(coordinate: .init(0, 0), direction: .down, steps: 0), heatLoss: 0),
                .init(location: .init(coordinate: .init(0, 0), direction: .right, steps: 0), heatLoss: 0),
            ]
            var heatLossMemo = [Location: Int]()

            while let current = steps.popMin() {
                if current.location.coordinate == end && movementRequirements.contains(current.location.steps) {
                    return current.heatLoss
                }

                // going further from here is pointless if a better path has already been plotted.
                if let heatLoss = heatLossMemo[current.location], heatLoss <= current.heatLoss {
                    continue
                }
                heatLossMemo[current.location] = current.heatLoss
                
                // enqueue valid turns, filling heat losses along the way if there's a minimum
                if (current.location.steps >= movementRequirements.lowerBound) {
                    let turns = current.location.direction.nextTurns()
                    let location0 = current.location.next(turns[0], distance: 1)
                    let location1 = current.location.next(turns[1], distance: 1)
                    if hIndices.contains(location0.coordinate.x) && vIndices.contains(location0.coordinate.y) {
                        steps.insert(.init(location: location0, heatLoss: current.heatLoss + heats[location0.coordinate.y][location0.coordinate.x]))
                    }
                    if hIndices.contains(location1.coordinate.x) && vIndices.contains(location1.coordinate.y) {
                        steps.insert(.init(location: location1, heatLoss: current.heatLoss + heats[location1.coordinate.y][location1.coordinate.x]))
                    }
                }

                // enqueue valid straight
                let distance = 1//current.location.steps > movementRequirements.lowerBound ? 1 : movementRequirements.lowerBound
                if (current.location.steps < movementRequirements.upperBound) {
                    let nextStraight = current.location.next(current.location.direction, distance: distance)
                    if hIndices.contains(nextStraight.coordinate.x) && vIndices.contains(nextStraight.coordinate.y) {
                        steps.insert(.init(location: nextStraight, heatLoss: current.heatLoss + heats[nextStraight.coordinate.y][nextStraight.coordinate.x]))
                    }
                }
            }

            // Couldn't find the end. We've lost *all* the heat. Christmas is ruined.
            return Int.max
        }
    }

    struct Step: Comparable {
        let location: Location
        let heatLoss: Int
        static func < (lhs: Day17.Step, rhs: Day17.Step) -> Bool { lhs.heatLoss < rhs.heatLoss }
    }

    struct Location: Hashable {
        let coordinate: Coordinate
        let direction: Direction
        let steps: Int

        func next(_ nextDirection: Direction, distance: Int) -> Location {
            return .init(
                coordinate: coordinate.move(distance, inDirection: nextDirection),
                direction: nextDirection,
                steps: nextDirection != direction ? distance : steps + distance
            )
        }
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

    enum Direction: Hashable {
        static let vertical = [Direction.up, Direction.down]
        static let horizontal = [Direction.left, Direction.right]
        case up, down, left, right
        func nextTurns() -> [Direction] {
            switch self {
            case .up, .down: Direction.horizontal
            case .left, .right: Direction.vertical
            }
        }
    }
}
