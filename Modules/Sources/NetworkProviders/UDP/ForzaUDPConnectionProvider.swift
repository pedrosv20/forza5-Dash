import Foundation
import Combine
import Network
import CocoaAsyncSocket

public enum CommonError: Error {
    case couldNotConnectToIP
}
public final class ForzaUDPConnectionProvider: NSObject, GCDAsyncUdpSocketDelegate {
    public static let shared: ForzaUDPConnectionProvider = .init()
    
    let port: UInt16 = 5000
    var socket: GCDAsyncUdpSocket?
    
    public lazy var asyncStream: AsyncStream<CarDashDTO> = .init { continuation in
        self.continuation = continuation
    }
    var continuation: AsyncStream<CarDashDTO>.Continuation?
    
    private override init() {
        super.init()
    }
    
    public func setupConnection() -> Bool {
        socket = GCDAsyncUdpSocket(
            delegate: self,
            delegateQueue: .main
        )
        socket?.setIPv4Enabled(true)
        
        do {
            try socket?.bind(toPort: port)
            try socket?.beginReceiving()
        } catch {
            self.continuation?.finish()
            return false
        }
        return true
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        self.continuation?.yield(ForzaDTOMapper.map(data: data))
    }
    
    deinit {
        socket?.close()
    }
}
