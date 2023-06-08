//
//  File.swift
//  
//
//  Created by Pedro Vargas on 07/06/23.
//

import Foundation


struct HandshakerResponse {
    var carName: String
    var driverName: String
    var identifier: Int
    var version: Int
    var trackName: String
    var trackConfig: String
}

enum HandshakerResponseMapper {
    static func convertBytesToHandshakerResponse(bytes: Data) -> HandshakerResponse? {
        guard bytes.count == 408 else { return nil }
        var response = HandshakerResponse(carName: "", driverName: "", identifier: 0, version: 0, trackName: "", trackConfig: "")
        
        let carNameData = bytes[0..<50]
        if let carName = String(bytes: carNameData, encoding: .utf16LittleEndian)?.trimmingCharacters(in: .whitespaces) {
            response.carName = carName
        }
        
        let driverNameData = bytes[50..<100]
        if let driverName = String(bytes: driverNameData, encoding: .utf16LittleEndian)?.trimmingCharacters(in: .whitespaces) {
            response.driverName = driverName
        }
        
        response.identifier = bytes[100..<104].intValue()
        response.version = bytes[104..<108].intValue()
        
        let trackNameData = bytes[108..<158]
        if let trackName = String(bytes: trackNameData, encoding: .utf16LittleEndian)?.trimmingCharacters(in: .whitespaces) {
            response.trackName = trackName
        }
        
        let trackConfigData = bytes[158..<208]
        if let trackConfig = String(bytes: trackConfigData, encoding: .utf16LittleEndian)?.trimmingCharacters(in: .whitespaces) {
            response.trackConfig = trackConfig
        }
        
        return response
    }

}

