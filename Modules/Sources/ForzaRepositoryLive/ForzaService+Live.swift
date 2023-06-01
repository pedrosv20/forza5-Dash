import Combine
import Dependencies
import ForzaRepository
import Foundation
import NetworkProviders

public extension ForzaService {
    static let live: Self = .init {
        UDPConnectionProvider
            .shared
            .getTelemetryData()
            .receive(on: DispatchQueue.main)
            .map { response in
                ForzaModel(
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
                    distanceTraveled: response.distanceTraveled
                )
            }
            .mapError { error in
                NSError.init(domain: "error", code: 10)
            }
            .eraseToAnyPublisher()
    }
}

extension ForzaService: DependencyKey {
    public static var liveValue: ForzaService = .live
}
