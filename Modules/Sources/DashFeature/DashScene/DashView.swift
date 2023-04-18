import SwiftUI
import Combine
import ComposableArchitecture
import CoreUI

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
                        .padding(.top, 12)
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
            .if(
                viewStore.state.model.gameIsRunning == false, transform: {
                    $0.overlay(alignment: .topLeading) {
                        Text(viewStore.state.ip)
                                .foregroundColor(.white)
                                .background(Color.black)
                    }
                })
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
            .threeColorProgressStyle()
        }
        .padding(.horizontal)
    }

    var isRaceOnView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .padding()
                .overlay(alignment: .top) {
                    Text("R A C E  O N")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.black)
                        .offset(y: -10)
                        .padding()
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
                        .padding(20)
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
                .padding()
        }
    }
    
    var rpmView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .padding()
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
                        .padding()
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
                .padding()
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
                    Text("B A R")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.black)
                        .offset(y: -10)
                }
                .padding()
            
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

