import Foundation

struct AssetoCorsaCarDTO {
    static var maxRPM: Float = 0
    static var idleRPM: Float = 5000
    var identifier: String?
    var size: Int
    var speed_Kmh: Int
    var speed_Mph: Int
    var speed_Ms: Int
    var isAbsEnabled: Bool
    var isAbsInAction: Bool
    var isTcInAction: Bool
    var isTcEnabled: Bool
    var isInPit: Bool
    var isEngineLimiterOn: Bool
    var accG_vertical: Float
    var accG_horizontal: Float
    var accG_frontal: Float
    var lapTime: Int
    var lastLap: Int
    var bestLap: Int
    var lapCount: Int
    var gas: Float
    var brake: Float
    var clutch: Float
    var engineRPM: Float
    var steer: Float
    var gear: Int
    
    func mapToCarDTO() -> CarDashDTO {
        if engineRPM > Self.maxRPM {
            Self.maxRPM = engineRPM
        }
        if engineRPM < Self.idleRPM, engineRPM != 0 {
            Self.idleRPM = engineRPM
        }
        return .init(
            gameIsRunning: true,
            maxRPM: Self.maxRPM,
            idleRPM:  Self.idleRPM,
            currentEngineRPM: engineRPM,
            accel: gas,
            brake: brake,
            clutch: clutch,
            handbrake: 0,
            gear: gear,
            boost: 0,
            speed: speed_Kmh,
            horsePower: 0,
            torque: 0,
            carOrdinal: 0,
            carClass: 0,
            carPerformanceIndex: 0,
            driveTrainType: 0,
            numOfCylinders: 0,
            distanceTraveled: 0,
            accelerationX: Double(accG_vertical),
            accelerationY: Double(accG_horizontal)
        )
    }
}
