import ComposableArchitecture
import ForzaRepository
import Foundation

public struct GForce: ReducerProtocol {
    public struct State: Equatable {
        public var model: ForzaModel
        public var ip: String
        
        public init(model: ForzaModel = .init(), ip: String = "not connected") {
            self.model = model
            self.ip = ip
        }
    }

    public enum Action {
        case onAppear
        case requestData
        case getIP
        case handleRequestedData(Result<ForzaModel, Error>)
    }
    @Dependency(\.forzaService) var forzaService
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.getIPAddressUseCase) var getIPAddressUseCase

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(.init(value: .getIP), .init(value: Action.requestData))

            case .requestData:
                return forzaService
                    .getForzaInfo()
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedData)


            case let .handleRequestedData(.success(model)):
                state.model = model
                return .none

            case .handleRequestedData(.failure(_)):
                return .none

            case .getIP:
                state.ip = getIPAddressUseCase.execute() ?? "cannot find IP"
                return .none
            }
        }
    }
}


