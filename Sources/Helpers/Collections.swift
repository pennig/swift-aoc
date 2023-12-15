public struct InfiniteIterator<Iterator : IteratorProtocol> : IteratorProtocol {
    private let original: Iterator
    private var current: Iterator

    public init(_ original: Iterator) {
        self.original = original
        self.current = original
    }

    public mutating func next() -> Iterator.Element? {
        if let next = current.next() {
            return next
        } else {
            current = original
            return current.next()
        }
    }
}

public extension IteratorProtocol {
    func forever() -> InfiniteIterator<Self> {
        return InfiniteIterator(self)
    }
}

extension Array{
    func columns<T>() -> [[T]] where Element == Array<T> {
        guard let count = first?.count else { return [] }
        return (0..<count).map { self[column: $0] }
    }

    subscript<T>(column c: Int) -> [T] where Element == Array<T> {
        get {
            map { $0[c] }
        }
        set {
            precondition(newValue.count == count)
            for i in self.indices {
                self[i][c] = newValue[i]
            }
        }
    }
}
