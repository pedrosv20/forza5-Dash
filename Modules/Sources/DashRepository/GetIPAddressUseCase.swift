import Dependencies
import Foundation

public struct GetIPAddressUseCase {
    public var execute: () -> String?
    
    public init(execute: @escaping () -> String?) {
        self.execute = execute
    }
}

extension GetIPAddressUseCase: TestDependencyKey {
    public static var testValue: GetIPAddressUseCase {
        .init(execute: { "192.168.0.1" })
    }
}

extension DependencyValues {
    public var getIPAddressUseCase:  GetIPAddressUseCase {
        get { self[GetIPAddressUseCase.self] }
        set { self[GetIPAddressUseCase.self] = newValue }
    }
}
