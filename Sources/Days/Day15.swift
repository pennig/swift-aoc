import Foundation
import Parsing

struct Day15: AdventDay {
    var data: Data

    var bytesArray: [ASCII] {
        data.withUnsafeBytes {
            $0.dropLast().split(separator: UInt8(ascii: ","), omittingEmptySubsequences: true).map {
                Array(UnsafeRawBufferPointer(rebasing: $0))
            }
        }
    }

    func part1() throws -> Any {
        return bytesArray.reduce(0) { $0 + $1.HASH }
    }

    func part2() throws -> Any {
        let keysAndValues: [(ASCII, INT?)] = bytesArray.map {
            if $0.last == UInt8(ascii: "-") {
                (Array($0.dropLast(1)), nil)
            } else {
                (Array($0.dropLast(2)), INT($0.last!) - 48)
            }
        }
        var MAP = HASHMAP()
        for pair in keysAndValues {
            MAP[pair.0] = pair.1
        }
        return MAP.POWER()
    }
}

// ALL-CAPS-TYPING

typealias UINT8 = UInt8
typealias UINT = UInt
typealias INT = Int
typealias ASCII = [UINT8]
extension Array {
    func REDUCE<RESULT>(_ INITIALRESULT: RESULT, _ NEXTPARTIALRESULT: (RESULT, Element) throws -> RESULT) rethrows -> RESULT {
        try self.reduce(INITIALRESULT, NEXTPARTIALRESULT)
    }
}
protocol HASHABLE: Equatable {
    var HASH: UINT { get }
}
extension ASCII: HASHABLE {
    var HASH: UINT {
        REDUCE(UINT(0)) {
            if $1 == 0xA { $0 } else { (($0 + UINT($1)) * 0x11) % 0x100 }
        }
    }
}

struct HASHMAP {
    struct LINKEDLIST {
        class NODE {
            let KEY: ASCII
            var VALUE: INT
            var NEXT: NODE?

            init(KEY: ASCII, VALUE: INT, NEXT: NODE? = nil) {
                self.KEY = KEY
                self.VALUE = VALUE
                self.NEXT = NEXT
            }
        }

        var HEAD: NODE?
        var TAIL: NODE?

        init() {}

        mutating func ADD(_ KEY: ASCII, _ VALUE: INT) {
            if HEAD == nil {
                HEAD = NODE(KEY: KEY, VALUE: VALUE, NEXT: nil)
                TAIL = HEAD
            } else {
                TAIL?.NEXT = NODE(KEY: KEY, VALUE: VALUE, NEXT: nil)
                TAIL = TAIL?.NEXT
            }
        }

        mutating func REMOVE(_ KEY: ASCII) {
            if HEAD?.KEY == KEY {
                HEAD = HEAD?.NEXT
            } else {
                var N = HEAD?.NEXT
                var P = HEAD
                while N != nil {
                    if N?.KEY == KEY {
                        P?.NEXT = N?.NEXT
                        if TAIL?.KEY == N?.KEY {
                            TAIL = P
                        }
                        return
                    }
                    P = N
                    N = N?.NEXT
                }
            }
            if HEAD == nil {
                TAIL = nil
            }
        }

        subscript(_ KEY: ASCII) -> NODE? {
            var N = HEAD
            while N != nil {
                if N?.KEY == KEY { return N }
                N = N?.NEXT
            }
            return nil
        }
    }

    private var STORAGE = [LINKEDLIST](repeating: .init(), count: 0x100)

    subscript(_ K: ASCII) -> INT? {
        get {
            STORAGE[INT(K.HASH)][K]?.VALUE
        }
        set {
            if let VALUE = newValue {
                if let NODE = STORAGE[INT(K.HASH)][K] {
                    NODE.VALUE = VALUE
                } else {
                    STORAGE[INT(K.HASH)].ADD(K, VALUE)
                }
            } else {
                STORAGE[INT(K.HASH)].REMOVE(K)
            }
        }
    }
}

extension HASHMAP {
    func POWER() -> INT {
        var total = 0
        for i in (0..<STORAGE.count) {
            total += (i + 1) * STORAGE[i].POWER()
        }
        return total
    }
}
extension HASHMAP.LINKEDLIST {
    func POWER() -> INT {
        var H = HEAD
        var i = 0
        var total = 0
        while H != nil {
            i += 1
            total += i * (H?.VALUE ?? 0)
            H = H?.NEXT
        }
        return total
    }
}
