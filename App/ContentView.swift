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
            Group {
                Color.blue
                Color.black.opacity(0.7)
            }
            .edgesIgnoringSafeArea(.all)
            
            Group {
                VStack {
                    HStack {
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
                                Spacer()
                    }
                    Spacer()
                }

                Text("\(viewModel.data?.speed ??  0) KM/h")
                    .foregroundColor(.white)
                    .font(.init(.system(size: 50)))
                    .onAppear {
                        viewModel.load()
                    }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(forzaService: .mock))
            .previewInterfaceOrientation(.landscapeRight)
    }
}
