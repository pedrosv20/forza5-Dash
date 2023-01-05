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
    @Published var data: ForzaModel?
    
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
            
            VStack(alignment: .center, spacing: 16) {
                rpmProgressView
                    .padding(.top, 6)
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
//                    boostView
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
        
        
    }
    
    var rpmProgressView: some View {
        ProgressView(
            value: viewModel.data?.currentEngineRPM ?? 0,
            total: viewModel.data?.maxRPM ?? 0
        )
        .progressViewStyle(RPMProgressViewStyle())
    }

    var isRaceOnView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .frame(width: 200, height: 100)
            .foregroundColor(.white)
            .overlay(
                Image(systemName:"flag.checkered.circle")
                    .symbolRenderingMode(.palette)
                    .if(
                        viewModel.data?.gameIsRunning ?? false,
                        transform: {
                            $0.foregroundStyle(.white, .green)
                        },
                        elseTransform: { $0.foregroundColor(.red)
                        }
                    )
                        .font(.init(.system(size: 35)))
                        .imageScale(.large)
            )
            .overlay(alignment: .top) {
                Text("RACING ON")
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(.black)
                    .offset(y: -10)
            }
        
    }
    
    var gearView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .frame(width: 150, height: 260)
            .foregroundColor(.white)
            .overlay(
                Text(String(viewModel.data?.gear ?? 0))
                    .foregroundColor(.white)
                    .font(.init(.system(size: 85)))
            )
            .overlay(alignment: .top) {
                Text("G E A R")
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(.black)
                    .offset(y: -10)
            }
    }
    
    var rpmView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .frame(width: 200, height: 100)
            .foregroundColor(.white)
            .overlay(
                Text(String(Int(viewModel.data?.currentEngineRPM ?? 00)))
                    .foregroundColor(.white)
                    .font(.init(.system(size: 40)))
            )
            .overlay(alignment: .top) {
                Text("R P M")
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(.black)
                    .offset(y: -10)
            }
    }
    
    var speedView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .if(
                viewModel.data?.speed ?? 0 > 0,
                transform: {
                    $0.background(
                        Color.green.opacity(0.7)
                            .frame(width: 200, height: 150)
                    )
                },
                elseTransform: {
                    $0.background(
                        Color.black
                            .frame(width: 200, height: 150)
                    )
                }
            )
            .frame(width: 200, height: 150)
            
            .foregroundColor(.white)
            .overlay(
                Text(String(viewModel.data?.speed ??  0))
                .foregroundColor(.white)
                .font(.init(.system(size: 60)))
            )
            .overlay(alignment: .top) {
                Text("K M / H")
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(.black)
                    .offset(y: -10)
            }
        
    }
    
    var boostView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .frame(width: 200, height: 150)
            .foregroundColor(.white)
            .overlay(
                Text(String(viewModel.data?.boost ??  0))
                .foregroundColor(.white)
                .font(.init(.system(size: 60)))
            )
            .overlay(alignment: .top) {
                Text("P S I")
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
            .previewInterfaceOrientation(.landscapeRight)
    }
}
