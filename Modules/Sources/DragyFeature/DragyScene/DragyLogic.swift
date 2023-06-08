import Foundation
import ComposableArchitecture
import ForzaRepository

public struct Dragy: ReducerProtocol {
    public struct State: Equatable {
        var model: ForzaModel
        var isDragyOn: Bool = false
        var elapsedTime: Double?
        var startDate: Double?
        var distanceTraveled: Int?
        var dragyType: DragyType
        var timeList: [String: String]

        public enum DragyType: String, Equatable, CaseIterable, Identifiable {
            case stoppedLaunch100 = "0-100km/h"
            case stoppedLaunch200 = "0-200km/h"
            case stoppedLaunch300 = "0-300km/h"

            case rollingLaunch100_200 = "100-200km/h"
            case rollingLaunch200_300 = "200-300km/h"
            case rollingLaunch100_300 = "100-300km/h"
            
            case drag18_9m = "60ft"
            case drag201m = "201m"
            case drag402m = "402m"
            
            public var id: String {
                self.rawValue
            }
        }

        public init(
            model: ForzaModel = .init(),
            isDragyOn: Bool = false,
            elapsedTime: Double? = nil,
            startDate: Double? = nil,
            dragyType: Dragy.State.DragyType = .stoppedLaunch100,
            timeList: [String: String] = [:]
        ) {
            self.model = model
            self.isDragyOn = isDragyOn
            self.elapsedTime = elapsedTime
            self.startDate = startDate
            self.dragyType = dragyType
            self.timeList = timeList
        }
        
    }

    public enum Action {
        case onAppear
        case loadData
        case handleLoadedData(Result<ForzaModel, Error>)
        case draggyButtonTapped(Bool)
        case handleDragy(State.DragyType)
        case updateDragyType(State.DragyType)
        case resetList
    }
    
    public init() {}
    
    @Dependency(\.forzaService) var forzaService
    @Dependency(\.mainQueue) var mainQueue
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .init(value: .loadData)

            case .loadData:
              return .run { send in
                for await model in forzaService.getForzaInfoAsync() {
                    await send(.handleLoadedData(.success(model)))
                }
            }


            case let .handleLoadedData(.success(model)):
                state.model = model
                if state.isDragyOn { return .init(value: .handleDragy(state.dragyType)) }
                return .none

            case .handleLoadedData(.failure(_)):
                return .none
            
            case let .draggyButtonTapped(bool):
                state.isDragyOn = bool
                if bool {
                    state.timeList = [:]
                    state.startDate = nil
                }
                return .none

            case .handleDragy(.stoppedLaunch100):
                stoppedLaunch(state: &state, topSpeed: 100)
                return .none

            case .handleDragy(.stoppedLaunch200):
                stoppedLaunch(state: &state, topSpeed: 200)
                return .none

            case .handleDragy(.stoppedLaunch300):
                stoppedLaunch(state: &state, topSpeed: 300)
                return .none
            case .handleDragy(.rollingLaunch100_200):
                rollingLaunch(state: &state, initSpeed: 100, topSpeed: 200)
                return .none
            case .handleDragy(.rollingLaunch200_300):
                rollingLaunch(state: &state, initSpeed: 200, topSpeed: 300)
                return .none
            case .handleDragy(.rollingLaunch100_300):
                rollingLaunch(state: &state, initSpeed: 100, topSpeed: 300)
                return .none
                
            case .handleDragy(.drag18_9m):
                dragMeters(state: &state, meters: 19)
                return .none

            case .handleDragy(.drag201m):
                dragMeters(state: &state, meters: 201)
                return .none

            case .handleDragy(.drag402m):
                dragMeters(state: &state, meters: 402)
                return .none

            case let .updateDragyType(type):
                state.dragyType = type
                return .none

            case .resetList:
                state.timeList = [:]
                return .none
            }
        }
    }
}

extension Dragy {
    func stoppedLaunch(state: inout Dragy.State, topSpeed: Int) {
        if state.model.speed != 0 {
            if let startDate = state.startDate {
                let elapsedTime = round((Date().timeIntervalSince1970 - startDate) * 1000) / 1000
                state.elapsedTime = elapsedTime
                if state.model.speed == 100, topSpeed != 100, state.timeList["100"] == nil {
                    state.timeList["100"] = "0-100: \(elapsedTime)s"
                }
                if state.model.speed == 200, topSpeed != 200, state.timeList["200"] == nil {
                    state.timeList["200"] = "0-200: \(elapsedTime)s"
                }
                if state.model.speed == 300, topSpeed != 300, state.timeList["300"] == nil{
                    state.timeList["300"] = "0-300: \(elapsedTime)s"
                }
                
                if state.model.speed == topSpeed {
                    state.timeList["\(topSpeed)"] = "0-\(topSpeed) in: \(elapsedTime)s"
                    state.isDragyOn = false
                    state.startDate = nil
                }
            } else {
                state.startDate = Date().timeIntervalSince1970
            }
        }
    }
    
    func rollingLaunch(state: inout Dragy.State, initSpeed: Int, topSpeed: Int) {
        if state.model.speed >= initSpeed {
            if let startDate = state.startDate {
                let elapsedTime = round((Date().timeIntervalSince1970 - startDate) * 1000) / 1000
                state.elapsedTime = elapsedTime
                if state.model.speed == 200, initSpeed != 200, topSpeed != 200, state.timeList["100"] == nil {
                    state.timeList["100"] = "\(initSpeed)-\(200): \(elapsedTime)s"
                }
                
                if state.model.speed == topSpeed {
                    state.timeList["\(topSpeed)"] = "\(initSpeed)-\(topSpeed) in: \(elapsedTime)s"
                    state.isDragyOn = false
                    state.startDate = nil
                }
            } else {
                state.startDate = Date().timeIntervalSince1970
            }
        }
    }
    
    func dragMeters(state: inout Dragy.State, meters: Int) {
        if state.model.speed != 0 {
            if let startDate = state.startDate, let distance = state.distanceTraveled {
                let elapsedTime = round((Date().timeIntervalSince1970 - startDate) * 1000) / 1000
                state.elapsedTime = elapsedTime
                
                let totalDistance = abs(state.model.distanceTraveled - distance)
                if totalDistance == 19, meters != 19 {
                    state.timeList["19m"] = "60ft \(elapsedTime)s \(state.model.speed)km/h"
                }
                
                if totalDistance == 201, meters != 201 {
                    state.timeList["201m"] = "201m \(elapsedTime)s \(state.model.speed)km/h"
                }
                
                if totalDistance == meters {
                    state.timeList["\(meters)m"] = "\(meters)m \(elapsedTime)s \(state.model.speed)km/h"
                    state.isDragyOn = false
                    state.startDate = nil
                    state.distanceTraveled = 0
                }
            } else {
                state.startDate = Date().timeIntervalSince1970
                state.distanceTraveled = state.model.distanceTraveled
            }
        }
    }
}
