import Combine
import Dependencies
import Foundation
import XCTestDynamicOverlay

public struct ForzaService{
    public var getForzaInfo: () -> AnyPublisher<ForzaModel, Error>
    
    public init(getForzaInfo: @escaping () -> AnyPublisher<ForzaModel, Error>) {
        self.getForzaInfo = getForzaInfo
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
        Timer.publish(every: 0.0001, on: .main, in: .default).autoconnect()
            .map { _ in
                if counter == 1000 {
                    counter = -1
                }
                counter += 1
                return ForzaModel.fixture(gameIsRunning: true, maxRPM: 1000, currentEngineRPM: Float(counter), speed: counter)
            }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif
