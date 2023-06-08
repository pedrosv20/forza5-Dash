import Foundation

public struct AssetoDTOMapper {
    static func decodeDataToAssetoDTO(_ data: Data) -> AssetoCorsaCarDTO? {
        var offset = 0
        
        let identifier = String(bytes: data[0..<1], encoding: .utf8)
        offset += 1
        
        let size = data[4..<8].intValue()
        
        let speed_Kmh = data[8..<12].floatValue()
         
        let speed_Mph = data[12..<16].floatValue()
        
        let speed_Ms = data[16..<20].floatValue()
        
        let isAbsEnabled = data[20] == 1
        offset += 1
        
        let isAbsInAction = data[21] == 1
        offset += 1
        
        let isTcInAction = data[22] == 1
        offset += 1
        
        let isTcEnabled = data[23] == 1
        offset += 1
        
        let isInPit = data[24] == 1
        offset += 1
        
        let isEngineLimiterOn = data[25] == 1
        offset += 1
        
        let accG_vertical = data[28..<32].floatValue()
        
        let accG_horizontal = data[32..<36].floatValue()
        
        let accG_frontal = data[36..<40].floatValue()
        
        let lapTime = data[40..<44].intValue()
        offset += 1
        
        let lastLap = data[44..<48].intValue()
        offset += 1
        
        let bestLap = data[48..<52].intValue()
        offset += 1
        
        let lapCount = data[52..<56].intValue()
        offset += 1
        
        let gas = data[56..<60].floatValue()
        
        let brake = data[60..<64].floatValue()
        
        let clutch = data[64..<68].floatValue()
        
        let engineRPM = data[68..<72].floatValue()
        
        let steer = data[72..<76].floatValue()
        
        let gear = {
            if Int(data[76]) - 1 == 0 {
                return 11
            } else if Int(data[76]) - 1 == -1 {
                return 0
            } else {
                return Int(data[76]) - 1
            }
        }()
        
        return .init(
            identifier: identifier,
            size: size,
            speed_Kmh: Int(speed_Kmh),
            speed_Mph: Int(speed_Mph),
            speed_Ms: Int(speed_Ms),
            isAbsEnabled: isAbsEnabled,
            isAbsInAction: isAbsInAction,
            isTcInAction: isTcInAction,
            isTcEnabled: isTcEnabled,
            isInPit: isInPit,
            isEngineLimiterOn: isEngineLimiterOn,
            accG_vertical: accG_vertical,
            accG_horizontal: accG_horizontal,
            accG_frontal: accG_frontal,
            lapTime: lapTime,
            lastLap: lastLap,
            bestLap: bestLap,
            lapCount: lapCount,
            gas: gas,
            brake: brake,
            clutch: clutch,
            engineRPM: engineRPM,
            steer: steer,
            gear: gear
        )
    }
}
