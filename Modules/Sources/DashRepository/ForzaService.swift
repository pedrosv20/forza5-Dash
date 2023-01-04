import Combine
import Foundation

public struct ForzaService{
    public var getForzaInfo: () -> AnyPublisher<ForzaModel, Error>
    
    public init(getForzaInfo: @escaping () -> AnyPublisher<ForzaModel, Error>) {
        self.getForzaInfo = getForzaInfo
    }
}
