// TODO: - Temporary View and udpConnection calling

import SwiftUI
import Combine
import CocoaAsyncSocket
import NetworkProviders
import DashRepository
import DashRepositoryLive

class ViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = .init()
    let forzaService: ForzaService
    @Published var data: ForzaModel = .init()
    
    init(forzaService: ForzaService = .live) {
        self.forzaService = forzaService
    }
    
    func load() {
        forzaService
            .getForzaInfo()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.data = response
                }
            )
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
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
            viewModel.load()
        }
        
        
    }
    
    var rpmProgressView: some View {
            ProgressView(
                value: viewModel.data.currentEngineRPM,
                total: viewModel.data.maxRPM
            )
            .frame(height: 60)
            .progressViewStyle(RPMProgressViewStyle())
    }

    var isRaceOnView: some View {
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
                        viewModel.data.gameIsRunning,
                        transform: {
                            $0.foregroundStyle(.white, .green)
                        },
                        elseTransform: { $0.foregroundColor(.red)
                        }
                    )
            )
            
        
    }
    
    var gearView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .foregroundColor(.white)
            .overlay(
                Text(viewModel.data.gear == 0 ? "R" : viewModel.data.gear == 11 ? "N" : String(viewModel.data.gear))
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
    
    var rpmView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
//            .frame(width: 200, height: 100)
            .foregroundColor(.white)
            .overlay(
                Text(String(Int(viewModel.data.currentEngineRPM)))
                    .foregroundColor(.white)
                    .font(.init(.system(size: 40)))
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
    
    var speedView: some View {
        Rectangle()
            .strokeBorder(.white, lineWidth: 3)
            .if(
                viewModel.data.accel != 0,
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
                Text(String(viewModel.data.speed))
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
    
    var boostView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
//            .frame(width: 200, height: 150)
            .foregroundColor(.white)
            .overlay(
                Text(String(viewModel.data.boost))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(forzaService: .mock))
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
            .previewDisplayName("ipad")
            .previewInterfaceOrientation(.landscapeRight)
//
//        ContentView(viewModel: .init(forzaService: .mock))
//            .previewDevice("iPhone 14 Pro Max")
//            .previewDisplayName("iphone")
//            .previewInterfaceOrientation(.landscapeRight)
    }
}
