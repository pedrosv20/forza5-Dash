// TODO: - Temporary View and udpConnection calling

import SwiftUI
import Combine
import CocoaAsyncSocket
import NetworkProviders
import DashRepository
import DashRepositoryLive

class ViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = .init()
    let forzaService: ForzaService = ForzaService.live
    @Published var data: ForzaModel?
    
    init() {}
    
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
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
//                .foregroundColor(gameIsRunning ? .green : .red)
//                .animation(.default, value: gameIsRunning)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("speed: \(viewModel.data?.speed ??  -59)")
                .onAppear {
                    viewModel.load()
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
