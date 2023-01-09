import Foundation
import Combine
import Network
import CocoaAsyncSocket

public enum CommonError: Error {
    case couldNotConnectToIP
}
public final class UDPConnectionProvider: NSObject, GCDAsyncUdpSocketDelegate {
    #if targetEnvironment(simulator)
    let ip: String = "192.168.0.23"
    #else
    let ip: String = "192.168.0.34"  // TODO: - Get ip from device that is running the app
    #endif
    public static let shared: UDPConnectionProvider = .init()
    
    let port: UInt16 = 5000
    var socket: GCDAsyncUdpSocket?
    let publisher: PassthroughSubject<ForzaDTO, CommonError> = .init()
    
    private override init() {
        super.init()
        setupConnection()
    }
    
    func setupConnection() {
        socket = GCDAsyncUdpSocket(
            delegate: self,
            delegateQueue: .main
        )
        socket?.setIPv4Enabled(true)
        
        do {
            try socket?.bind(toPort: port, interface: ip)
            try socket?.beginReceiving()
        } catch {
            publisher.send(completion: .failure(.couldNotConnectToIP))
        }
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        publisher.send(ForzaDTOMapper.map(data: data))
    }
    
    public func getTelemetryData() -> AnyPublisher<ForzaDTO, CommonError> {
        publisher.eraseToAnyPublisher()
    }
    
    
    deinit {
        socket?.close()
    }
}
