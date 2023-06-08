import Combine
import Dependencies
import Foundation

public struct ForzaService{
    public var getForzaInfoAsync: () -> AsyncStream<ForzaModel>
    
    public init(getForzaInfoAsync: @escaping () ->  AsyncStream<ForzaModel>) {
        self.getForzaInfoAsync = getForzaInfoAsync
    }
}

extension ForzaService: TestDependencyKey {
    public static let testValue: ForzaService = .mock
}

extension DependencyValues {
    public var forzaService:  ForzaService {
        get { self[ForzaService.self] }
        set { self[ForzaService.self] = newValue }
    }
}

#if DEBUG
public extension ForzaService {
    static var counter = -1
    static let mock: Self = .init {
        AsyncStream(
            ForzaModel.self, {
                continuation in
                Task {
                    while true {
                        if counter == 1000 {
                            counter = -1
                        }
                        counter += 1
                        
                        continuation.yield(.fixture(gameIsRunning: true, speed: counter))
                        
                        try? await Task.sleep(nanoseconds: 1_000)
                    }
                }
            }
        )
    }
}
#endif
