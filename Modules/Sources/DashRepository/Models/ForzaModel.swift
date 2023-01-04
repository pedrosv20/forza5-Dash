import Foundation

public struct ForzaModel {
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
    
    public init(
        gameIsRunning: Bool,
        maxRPM: Float,
        idleRPM: Float,
        currentEngineRPM: Float,
        accel: Float,
        brake: Float,
        clutch: Float,
        handbrake: Float,
        gear: Int,
        boost: Float,
        speed: Int,
        horsePower: Float,
        torque: Float,
        carOrdinal: Int,
        carClass: Int,
        carPerformanceIndex: Int,
        driveTrainType: Int,
        numOfCylinders: Int
    ) {
        self.gameIsRunning = gameIsRunning
        self.maxRPM = maxRPM
        self.idleRPM = idleRPM
        self.currentEngineRPM = currentEngineRPM
        self.accel = accel
        self.brake = brake
        self.clutch = clutch
        self.handbrake = handbrake
        self.gear = gear
        self.boost = boost
        self.speed = speed
        self.horsePower = horsePower
        self.torque = torque
        self.carOrdinal = carOrdinal
        self.carClass = carClass
        self.carPerformanceIndex = carPerformanceIndex
        self.driveTrainType = driveTrainType
        self.numOfCylinders = numOfCylinders
    }
}
