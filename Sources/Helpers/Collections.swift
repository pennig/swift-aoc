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


