import Foundation

public struct ForzaDTOMapper {
    static var currentCar: Int = 0
    static var hasTurbo = true
    static func map(data: Data) -> CarDashDTO {
        
        let carOrdinal: Int = {
            let car = data[212..<216].intValue()
            return car
        }()

        let boost: Float = {
            let boostValue: Float = data[284..<288].floatValue()

            if
                carOrdinal != currentCar,
                boostValue > -14,
                boostValue != 0.0 {
                hasTurbo = true
            } else if
                carOrdinal != currentCar,
                boostValue < -14,
                boostValue != 0.0 {
                hasTurbo = false
            }
            let normalizedBoost = boostValue / 14.5065759358
            let roundedData: Float = round(normalizedBoost * 100) / 100
            return hasTurbo ? roundedData : 0
        }()

        if currentCar != carOrdinal {
            currentCar = carOrdinal
        }
        
        let speed: Int = {
            let speedValue: Float = data[256..<260].floatValue()
            let normalizedSpeed = Int(speedValue * 3.6)
            return normalizedSpeed
        }()

        let horsePower: Float = {
            let horsePowerValue: Float = data[260..<264].floatValue()
            let normalizedHP = horsePowerValue * 0.00134102
            let roundedHorsePower: Float = round(normalizedHP * 100) / 100
            return roundedHorsePower > 0 ? roundedHorsePower : 0
        }()

        let torque: Float = {
            let torqueValue: Float = data[264..<268].floatValue()
            let normalizedTorque = torqueValue * 0.102
            let roundedTorque = round(normalizedTorque * 100) / 100
            return roundedTorque > 0 ? roundedTorque : 0
        }()
        
        let distanceTraveled: Int = {
            let distanceTraveledValue: Float = data[292..<296].floatValue()
            let normalizedDistanceTraveled = distanceTraveledValue /  1.8652
            return Int(normalizedDistanceTraveled)
        }()
        
        let accelerationX: Double = {
           let rawAccelerationX = data[20..<24].floatValue()
            return round(Double(rawAccelerationX) * -100)
        }()
        
        let accelerationY: Double = {
           let rawAccelerationY = data[28..<32].floatValue()
            return round(Double(rawAccelerationY) * 100)
        }()
        
        return .init(
            gameIsRunning: data[0] == 1,
            maxRPM: data[8..<12].floatValue(),
            idleRPM: data[12..<16].floatValue(),
            currentEngineRPM: data[16..<20].floatValue(),
            accel: Float(data[315]),
            brake: Float(data[316]),
            clutch: Float(data[317]),
            handbrake: Float(data[318]),
            gear: Int(data[319]),
            boost: boost,
            speed: speed,
            horsePower: horsePower,
            torque: torque,
            carOrdinal: currentCar,
            carClass: data[216..<220].intValue(),
            carPerformanceIndex: data[220..<224].intValue(),
            driveTrainType: data[224..<228].intValue(),
            numOfCylinders: data[228..<232].intValue(),
            distanceTraveled: distanceTraveled,
            accelerationX: accelerationX,
            accelerationY: accelerationY
        )
        
        
    }
}

extension Data { // add to extensions
    func floatValue() -> Float {
        Float(bitPattern: UInt32(littleEndian: self.withUnsafeBytes { $0.load(as: UInt32.self) }))
    }
    
    func intValue() -> Int {
    Int(UInt32(littleEndian: self.withUnsafeBytes { $0.load(as: UInt32.self)   }))
    }
}
