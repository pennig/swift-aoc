import Algorithms
import Foundation

struct Day13: AdventDay {
    var data: Data

    func grids() -> [Grid] {
        data.withUnsafeBytes {
            $0.split(separator: UInt8(ascii: "\n"), omittingEmptySubsequences: false)
                .split(whereSeparator: { $0.isEmpty })
                .map {
                    $0.map {
                        Array(String(decoding: UnsafeRawBufferPointer(rebasing: $0), as: UTF8.self)
                            .replacingOccurrences(of: ".", with: "0")
                            .replacingOccurrences(of: "#", with: "1"))
                    }
                }
        }.map(Grid.init)
    }

    func part1() throws -> Any {
        return grids().reduce(0) {
            let location = $1.mirrorLocation()
            return if let row = location.row {
                $0 + row * 100
            } else if let col = location.col {
                $0 + col
            } else {
                $0
            }
        }
    }

    func part2() throws -> Any {
        return grids().reduce(0) {
            let location = $1.differentMirrorLocation()
            return if let row = location.row {
                $0 + row * 100
            } else if let col = location.col {
                $0 + col
            } else {
                $0
            }
        }
    }

    struct Grid: Hashable {
        let characters: [[Character]]

        init(_ characters: [[Character]]) {
            self.characters = characters
        }

        func mirrorLocation() -> (row: Int?, col: Int?) {
            return mirrorLocation(characters: self.characters)
        }

        func mirrorLocation(characters: [[Character]], original: (row: Int?, col: Int?) = (nil, nil)) -> (row: Int?, col: Int?) {
            let rows = characters.map {
                Int(String($0), radix: 2)!
            }
            if let rowReflection = rows.mirrorIndex(ignoring: original.row) {
                return (rowReflection, nil)
            }
            let columns = (0..<characters[0].count).map { index in
                Int(String(characters.map { $0[index] }), radix: 2)!
            }
            if let columnReflection = columns.mirrorIndex(ignoring: original.col) {
                return (nil, columnReflection)
            }

            return (nil, nil)
        }

        func differentMirrorLocation() -> (row: Int?, col: Int?) {
            var characters = characters
            let original = mirrorLocation(characters: characters)
            for row in (0..<characters.count) {
                for col in (0..<characters[0].count) {
                    let char = characters[row][col]
                    defer { characters[row][col] = char }
                    characters[row][col] = char == "1" ? "0" : "1"
                    let new = mirrorLocation(characters: characters, original: original)
                    if new.col != nil || new.row != nil {
                        return new
                    }
                }
            }

            return original
        }
    }
}

extension [Int] {
    func mirrorIndex(ignoring: Int? = nil) -> Int? {
        for pair in adjacentPairs().enumerated() {
            if pair.element.0 == pair.element.1 {
                // I put my thing down, zip it and reverse it
                if zip(
                    self[0...pair.offset].reversed(),
                    self[(pair.offset+1)...]
                ).allSatisfy({ $0 == $1 }) {
                    if let ignoring, ignoring == pair.offset + 1 { continue }
                    return pair.offset + 1
                }
            }
        }
        return nil
    }
}
