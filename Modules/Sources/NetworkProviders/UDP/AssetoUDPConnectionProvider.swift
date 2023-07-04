import Foundation
import Combine
import Network
import CocoaAsyncSocket

public final class AssetoUDPConnectionProvider: NSObject, GCDAsyncUdpSocketDelegate {
    public static let shared: AssetoUDPConnectionProvider = .init()
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
        let host = "192.168.0.22"
        let port: UInt16 = 9996
        do {
            try socket?.connect(toHost: host, onPort: port)
            try socket?.beginReceiving()
        } catch {
            return false
        }
        
        let dataToEncode = HandshakerRequest(identifier: 0, version: 1, operationID: 0).convertToData()

        socket?.send(dataToEncode, withTimeout: -1, tag: 0)
        return true
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        if let _ = HandshakerResponseMapper.convertBytesToHandshakerResponse(bytes: data) {
            let dataToEncode = HandshakerRequest(identifier: 0, version: 1, operationID: 1).convertToData()
            socket?.send(dataToEncode, withTimeout: -1, tag: 0)
        }
        else if let assetoDTO = AssetoDTOMapper.decodeDataToAssetoDTO(data) {
            continuation?.yield(assetoDTO.mapToCarDTO())
        }

    }
    
    // TODO: disconnect every time changing screen?
    deinit {
        socket?.close()
    }
}
