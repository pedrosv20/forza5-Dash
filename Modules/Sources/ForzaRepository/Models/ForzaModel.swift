import Foundation

public struct ForzaModel: Equatable {
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
    public let accelerationX: Double
    public let accelerationY: Double
    
    public init(
        gameIsRunning: Bool = false,
        maxRPM: Float = 0,
        idleRPM: Float = 0,
        currentEngineRPM: Float = 0,
        accel: Float = 0,
        brake: Float = 0,
        clutch: Float = 0,
        handbrake: Float = 0,
        gear: Int = 11,
        boost: Float = 0,
        speed: Int = 0,
        horsePower: Float = 0,
        torque: Float = 0,
        carOrdinal: Int = 0,
        carClass: Int = 0,
        carPerformanceIndex: Int = 0,
        driveTrainType: Int = 0,
        numOfCylinders: Int = 0,
        distanceTraveled: Int = 0,
        accelerationX: Double = 0.0,
        accelerationY: Double = 0.0
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
        self.distanceTraveled = distanceTraveled
        self.accelerationX = accelerationX
        self.accelerationY = accelerationY
    }
}

#if DEBUG
public extension ForzaModel {
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
        distanceTraveled: Int = 0,
        accelerationX: Double = 0,
        accelerationY: Double = 0
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
            distanceTraveled: distanceTraveled,
            accelerationX: accelerationX,
            accelerationY: accelerationY
        )
        
    }
}
#endif
