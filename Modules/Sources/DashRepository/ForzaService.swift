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
    public static let testValue = Self(getForzaInfo: unimplemented("getForzaInfo"))
}

extension DependencyValues {
    public var forzaService:  ForzaService {
        get { self[ForzaService.self] }
        set { self[ForzaService.self] = newValue }
    }
}
