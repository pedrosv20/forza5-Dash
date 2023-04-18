import SwiftUI
import Combine
import ComposableArchitecture
import CoreUI
import Charts


public struct GForceView: View {
    var store: StoreOf<GForce>
    
    public init(store: StoreOf<GForce>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                if
                    let accelerationX = viewStore.state.model.accelerationX,
                    let accelerationY = viewStore.state.model.accelerationY {
                    Rectangle()
                        .stroke(lineWidth: 3)
                        .foregroundColor(.red)
                        .overlay {
                            ZStack {
                                Path() { path in
                                    path.move(to: .init(x: 100 * 2, y: 100 * 2))
                                    path.addLine(to: .init(x: 100 * 2 + accelerationX / 27 * 2, y: 100 * 2 + accelerationY / 27 * 2))
                                }
                                .stroke(lineWidth: 1)
                                .fill(Color.red)
                                
                                Circle()
//                                    .clipped()
                                    .foregroundColor(Color.yellow)
                                    .frame(width: 10, height:10)
                                    .position(x: 100 * 2 + accelerationX / 27 * 2, y: 100 * 2 + accelerationY / 27 * 2)
                            }
                            .clipped()
                            
                        }
                        .frame(width: 200 * 2, height: 200 * 2, alignment: .center)
                }
                
            }
            .if(
                viewStore.state.model.gameIsRunning == false, transform: {
                    $0.overlay(alignment: .topLeading) {
                        Text(viewStore.state.ip)
                                .foregroundColor(.white)
                                .background(Color.black)
                    }
                }
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
