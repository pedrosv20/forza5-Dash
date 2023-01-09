import SwiftUI
import Combine
import CocoaAsyncSocket
import NetworkProviders
import DashRepository
import DashRepositoryLive // TODO: - Implement DI system

enum DragyType {
    case stoppedLaunch
    case launch800m
    case launch400m
    case launch200m
}

class DragyViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = .init()
    let forzaService: ForzaService // TODO: - create DashModel aka Forza model and draggy model
    var dragyType: DragyType
    var isDragyOn: Bool = false
    var startDate: Double?
    @Published var data: ForzaModel = .init()
    @Published var distanceTraveled: Float = 0
    @Published var seconds: Float = 0.0
    
    init(
        forzaService: ForzaService = .live,
        dragyType: DragyType = .stoppedLaunch
    ) {
        self.forzaService = forzaService
        self.dragyType = dragyType
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
    
    func turnOnDragy() {
        switch dragyType {
        case .stoppedLaunch:
            isDragyOn = true
            stoppedLaunchDragy()
        default:
            return
        }
    }
    
    private func stoppedLaunchDragy() {
        self.$data
            .sink(receiveValue: { [weak self] value in
                guard let self, self.isDragyOn else { return }
                if value.speed != 0 {
                    if self.startDate == nil {
                        self.startDate = Date().timeIntervalSince1970
                    }
                    print("time: \(Date().timeIntervalSince1970 - self.startDate!))")
                    if value.speed == 100 {
                        print("0km/h - 100km/h in: \(Date().timeIntervalSince1970 - self.startDate!)")
                        print("end")
                        self.isDragyOn = false
                        self.startDate = nil
                    }
                }
            })
            .store(in: &cancellables)
    }
}

struct DragyView: View {
    @ObservedObject var viewModel: DragyViewModel = DragyViewModel()

    var body: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.all)
            
        
            VStack(alignment: .center, spacing: 12) {
                rpmProgressView
                    .padding(.top, 12)
                Spacer()
                HStack(spacing: 16) {
                    infoList
                    
                    Spacer()
                    
                    
                    speedView
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
                    .background(.blue)
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
                            $0.foregroundStyle(viewModel.isDragyOn ? .pink : .white, .green)
                        },
                        elseTransform: { $0.foregroundColor(.red)
                        }
                    )
                    .onTapGesture {
                        viewModel.turnOnDragy()
                    }
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
                    .background(.blue)
                    .offset(y: -10)
            }
    }
    
    var infoList: some View {
        List {
            HStack {
                Text("123")
            }
                
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .background(Color.white)
        .padding()
    }
 
    var speedView: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .foregroundColor(.white)
            .overlay(alignment: .center) {
                Text(String(viewModel.data.speed))
                    .foregroundColor(.white)
                    .font(.init(.system(size: 60)))
                +
                Text("km/h")
                    .foregroundColor(.white)
                    .font(.init(.system(size: 20)))
            }
            .padding()
//        Circle()
//            .stroke(lineWidth: 30)
//            .foregroundColor(.white)
//            .padding()
//            .overlay(alignment: .center) {
//
//            }
    }
}

struct DragyView_Previews: PreviewProvider {
    static var previews: some View {
        DragyView(viewModel: .init(forzaService: .mock))
            .previewDevice("iPhone 14 Pro Max")
            .previewDisplayName("iPhone")
            .previewInterfaceOrientation(.landscapeRight)
    }
}
