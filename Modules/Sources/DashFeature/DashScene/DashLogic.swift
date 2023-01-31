import ComposableArchitecture
import DashRepository
import Foundation

public struct Dash: ReducerProtocol {
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
                state.ip = getIPAddress() ?? "cannot find IP"
                return .none
            }
        }
    }
}

func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6),
                    let cString = interface?.ifa_name,
                    String(cString: cString) == "en0",
                    let saLen = (interface?.ifa_addr.pointee.sa_len) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    let ifaAddr = interface?.ifa_addr
                    getnameinfo(ifaAddr,
                                socklen_t(saLen),
                                &hostname,
                                socklen_t(hostname.count),
                                nil,
                                socklen_t(0),
                                NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }

