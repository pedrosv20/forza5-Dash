import Combine
import Dependencies
import Foundation

public struct AssetoService {
    public var getAssetoInfo: () -> AsyncStream<CarDashModel>
    public var connect: () -> Bool
    
    public init(
        getAssetoInfo: @escaping () ->  AsyncStream<CarDashModel>,
        connect: @escaping () -> Bool
    ) {
        self.getAssetoInfo = getAssetoInfo
        self.connect =  connect
    }
}

extension AssetoService: TestDependencyKey {
    public static let testValue: AssetoService = .mock
}

extension DependencyValues {
    public var assetoService:  AssetoService {
        get { self[AssetoService.self] }
        set { self[AssetoService.self] = newValue }
    }
}

#if DEBUG
public extension AssetoService {
    static var counter = -1
    static let mock: Self = .init {
        AsyncStream(
            CarDashModel.self, {
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
    } connect: {
        false
    }
}
#endif
