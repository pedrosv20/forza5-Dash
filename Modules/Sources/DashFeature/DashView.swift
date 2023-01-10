import SwiftUI
import Combine
import ComposableArchitecture
import DashRepository

public enum CommonError: Error {
    case couldNotConnectToIP
}

public struct Dash: ReducerProtocol {
    public struct State: Equatable {
        public var model: ForzaModel
        
        public init(model: ForzaModel) {
            self.model = model
        }
    }

    public enum Action {
        case onAppear
        case requestData
        case handleRequestedData(Result<ForzaModel, Error>)
    }
    let mainQueue: DispatchQueue = .main
    @Dependency(\.forzaService) var forzaService

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .init(value: .requestData)

            case .requestData:
                return forzaService
                    .getForzaInfo()
                    .receive(on: DispatchQueue.main)
                    .catchToEffect()
                    .map(Action.handleRequestedData)


            case let .handleRequestedData(.success(model)):
                state.model = model
                return .none

            case .handleRequestedData(.failure(_)):
                return .none
            }
        }
    }
}


public struct DashView: View {
    var store: StoreOf<Dash>
    
    public init(store: StoreOf<Dash>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            
            
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack(alignment: .center, spacing: 12) {
                    rpmProgressView
                        .padding(.top, 6)
                    Spacer()
                    HStack(spacing: 16) {
                        VStack(spacing: 16) {
                            rpmView
                            speedView
                        }
                        Spacer()
                        
                        gearView
                        
                        Spacer()
                        
                        VStack(spacing: 16) {
                            isRaceOnView
                            boostView
                        }
                    }
                }
                
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    var rpmProgressView: some View {
        WithViewStore(store) { viewStore in
            ProgressView(
                value: viewStore.state.model.currentEngineRPM,
                total: viewStore.state.model.maxRPM
            )
            .frame(height: 60)
            .progressViewStyle(RPMProgressViewStyle())
        }
    }

    var isRaceOnView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .overlay(alignment: .top) {
                    Text("R A C E  O N")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.black)
                        .offset(y: -10)
                }
                .overlay(
                    Image(systemName:"flag.checkered.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.8)
                        .symbolRenderingMode(.palette)
                        .if(
                            viewStore.state.model.gameIsRunning,
                            transform: {
                                $0.foregroundStyle(.white, .green)
                            },
                            elseTransform: { $0.foregroundColor(.red)
                            }
                        )
                )
        }
            
        
    }
    
    var gearView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .overlay(
                    Text(
                        viewStore.state.model.gear == 0 ? "R" :
                            viewStore.state.model.gear == 11 ? "N" :
                            String(viewStore.state.model.gear)
                    )
                    .foregroundColor(.white)
                    .font(.init(.system(size: 100)))
                )
                .overlay(alignment: .top) {
                    Text("G E A R")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.black)
                        .offset(y: -10)
                }
        }
    }
    
    var rpmView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .overlay(
                    Text(String(Int(viewStore.state.model.currentEngineRPM)))
                        .foregroundColor(.white)
                        .font(.init(.system(size: 60)))
                )
                .overlay(alignment: .top) {
                    Text("R P M")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.black)
                        .offset(y: -10)
                }
        }
    }
    
    var speedView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .strokeBorder(.white, lineWidth: 3)
                .if(
                    viewStore.state.model.accel != 0,
                    transform: {
                        $0.background(
                            Rectangle().fill(.green)
                        )
                    },
                    elseTransform: {
                        $0.background(
                            Rectangle().fill(.black)
                        )
                    }
                )
                    .overlay(
                        Text(String(viewStore.state.model.speed))
                            .foregroundColor(.white)
                            .font(.init(.system(size: 60)))
                    )
                        .overlay(alignment: .top) {
                    Text("K M / H")
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.black)
                        .font(.title3)
                        .offset(y: -10)
                }
        }
    }
    
    var boostView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .overlay(
                    Text(String(viewStore.state.model.boost))
                        .foregroundColor(.white)
                        .font(.init(.system(size: 60)))
                )
                .overlay(alignment: .top) {
                    Text("P S I")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.black)
                        .offset(y: -10)
                }
            
        }
    }
}
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: ((Self) -> Content)) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<IFContent: View, ElseContent: View>(
        _ condition: Bool,
        transform: ((Self) -> IFContent),
        elseTransform: ((Self) -> ElseContent)
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
}

struct RPMProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { gproxy in
            Rectangle()
                .stroke(lineWidth: 3)
                .frame(height: 60)
                .foregroundColor(.white)
                .background(alignment: .leading) { Color.red
                        .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * gproxy.size.width
                        )
                }
            //TODO: break into 3 parts green yellow and red
        }
    }
}

//struct DashView_Previews: PreviewProvider {
//    static var previews: some View {
////        DashView(viewModel: .init(forzaService: .mock))
////            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
////            .previewDisplayName("ipad")
////            .previewInterfaceOrientation(.landscapeRight)
////
////        ContentView(viewModel: .init(forzaService: .mock))
////            .previewDevice("iPhone 14 Pro Max")
////            .previewDisplayName("iphone")
////            .previewInterfaceOrientation(.landscapeRight)
//    }
//}

