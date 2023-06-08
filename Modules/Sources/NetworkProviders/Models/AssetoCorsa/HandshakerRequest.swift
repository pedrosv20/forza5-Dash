//
//  File.swift
//  
//
//  Created by Pedro Vargas on 07/06/23.
//

import Foundation

struct HandshakerRequest: Encodable {
    let identifier: Int32
    let version: Int
    let operationID: Int32
    
    func convertToData() -> Data {
        var message = Data(count: 12)

        message.replaceSubrange(0..<4, with: withUnsafeBytes(of: identifier.littleEndian) { Data($0) })
        message.replaceSubrange(4..<8, with: withUnsafeBytes(of: version.littleEndian) { Data($0) })
        message.replaceSubrange(8..<12, with: withUnsafeBytes(of: operationID.littleEndian) { Data($0) })
        
        return message
    }
}
