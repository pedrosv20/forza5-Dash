import Combine
import Dependencies
import CarDataRepository
import Foundation
import NetworkProviders

public extension AssetoService {
    static let live: Self = .init {
        let sequence = AssetoUDPConnectionProvider.shared
            .asyncStream
            .map { response in
                CarDashModel(
                    gameIsRunning: response.gameIsRunning,
                    maxRPM: response.maxRPM,
                    idleRPM: response.idleRPM,
                    currentEngineRPM: response.currentEngineRPM,
                    accel: response.accel,
                    brake: response.brake,
                    clutch: response.clutch,
                    handbrake: response.handbrake,
                    gear: response.gear,
                    boost: response.boost,
                    speed: response.speed,
                    horsePower: response.horsePower,
                    torque: response.torque,
                    carOrdinal: response.carOrdinal,
                    carClass: response.carClass,
                    carPerformanceIndex: response.carPerformanceIndex,
                    driveTrainType: response.driveTrainType,
                    numOfCylinders: response.numOfCylinders,
                    distanceTraveled: response.distanceTraveled,
                    accelerationX: response.accelerationX,
                    accelerationY: response.accelerationY
                )
            }
        return AsyncStream(sequence)
    } connect: {
        AssetoUDPConnectionProvider.shared.setupConnection()
    }
}

extension AssetoService: DependencyKey {
    public static var liveValue: AssetoService = .live
}
