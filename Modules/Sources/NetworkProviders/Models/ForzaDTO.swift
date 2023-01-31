import Foundation

public struct ForzaDTO {
    public let gameIsRunning: Bool
    public let maxRPM: Float
    public let idleRPM: Float
    public let currentEngineRPM: Float
    public let accel: Float
    public let brake: Float
    public let clutch: Float
    public let handbrake: Float
    public let gear: Int
    public let boost: Float
    public let speed: Int
    public let horsePower: Float
    public let torque: Float
    public let carOrdinal: Int
    public let carClass: Int
    public let carPerformanceIndex: Int
    public let driveTrainType: Int
    public let numOfCylinders: Int
    public let distanceTraveled: Int
}

#if DEBUG
public extension ForzaDTO {
    static func fixture(
        gameIsRunning: Bool = true,
        maxRPM: Float = 8000,
        idleRPM: Float = 1000,
        currentEngineRPM: Float = 2000,
        accel: Float = 255,
        brake: Float = 255,
        clutch: Float = 255,
        handbrake: Float = 255,
        gear: Int = 2,
        boost: Float = 1.0,
        speed: Int = 30,
        horsePower: Float = 200,
        torque: Float = 50,
        carOrdinal: Int = 10,
        carClass: Int = 3,
        carPerformanceIndex: Int = 700,
        driveTrainType: Int = 2,
        numOfCylinders: Int = 6,
        distanceTraveled: Int = 0
    ) -> Self {
        self.init(
            gameIsRunning: gameIsRunning,
            maxRPM: maxRPM,
            idleRPM: idleRPM,
            currentEngineRPM: currentEngineRPM,
            accel: accel,
            brake: brake,
            clutch: clutch,
            handbrake: handbrake,
            gear: gear,
            boost: boost,
            speed: speed,
            horsePower: horsePower,
            torque: torque,
            carOrdinal: carOrdinal,
            carClass: carClass,
            carPerformanceIndex: carPerformanceIndex,
            driveTrainType: driveTrainType,
            numOfCylinders: numOfCylinders,
            distanceTraveled: distanceTraveled
        )
        
    }
}
#endif
