import Foundation
import Combine
import Network
import CocoaAsyncSocket

public enum CommonError: Error {
    case couldNotConnectToIP
}
public final class UDPConnectionProvider: NSObject, GCDAsyncUdpSocketDelegate {
    #if targetEnvironment(simulator)
    let ip: String = "192.168.0.28"
    #else
    let ip: String = "192.168.0.34"
    #endif
//    #if targetEnvironment(simulator)
//    let ip: String = "192.168.0.28"
//    #else
//    let ip: String = "192.168.0.34" // TODO: - Get ip from device that is running the app
//    #endif
    public static let shared: UDPConnectionProvider = .init()
    
    let port: UInt16 = 5000
    var socket: GCDAsyncUdpSocket?
    public let publisher: PassthroughSubject<ForzaResponse, CommonError> = .init()
    
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
//            try socket?.bind(toPort: port)
            try socket?.beginReceiving()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        publisher.send(ForzaResponseMapper.map(data: data))
        print("receivedData when game is not paused.")
    }
    
    deinit {
        socket?.close()
    }
}
