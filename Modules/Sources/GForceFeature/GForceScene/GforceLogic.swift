import ComposableArchitecture
import CarDataRepository
import Foundation

public struct GForce: ReducerProtocol {
    public struct State: Equatable {
        public var model: CarDashModel
        public var ip: String
        
        public init(model: CarDashModel = .init(), ip: String = "not connected") {
            self.model = model
            self.ip = ip
        }
    }

    public enum Action {
        case onAppear
        case connectToService
        case requestData
        case getIP
        case handleRequestedData(Result<CarDashModel, Error>)
    }
    @Dependency(\.forzaService) var forzaService
    @Dependency(\.assetoService) var assetoService
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.getIPAddressUseCase) var getIPAddressUseCase

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(.task { .getIP }, .task { .connectToService })
                
            case .connectToService:
                let forzaConnected = forzaService.connect()
                let assetoConnected = assetoService.connect()
                if assetoConnected || forzaConnected {
                    return .task { .requestData }
                } else {
                    return .none
                }

            case .requestData:
                return .merge(
                    .run { send in
                        for await model in assetoService.getAssetoInfo() {
                            await send(.handleRequestedData(.success(model)))
                        }
                    },
                    .run { send in
                        for await model in forzaService.getForzaInfo() {
                            await send(.handleRequestedData(.success(model)))
                        }
                    }
                )


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


