import ComposableArchitecture
import Combine
import Dependencies
import Foundation
import NetworkProviders
import DashRepository

public extension ForzaService {
    static let live: Self = .init {
        UDPConnectionProvider
            .shared
            .getTelemetryData()
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
                    numOfCylinders: response.numOfCylinders
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


#if DEBUG
public extension ForzaService {
    static var counter = -1
    static let mock: Self = .init {
        Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
            .map { _ in
                if counter == 100 {
                    counter = -1
                }
                counter += 1
                return ForzaModel.fixture(gameIsRunning: true, speed: counter)
            }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif
