
public extension AsyncStream {
    init<Sequence: AsyncSequence>(_ sequence: Sequence) where Sequence.Element == Element {
        self.init {
            var iterator: Sequence.AsyncIterator?
            if iterator == nil {
                iterator = sequence.makeAsyncIterator()
            }
            return try? await iterator?.next()
        }
    }
}
