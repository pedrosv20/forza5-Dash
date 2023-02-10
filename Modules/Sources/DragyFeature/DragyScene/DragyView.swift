import SwiftUI
import Combine
import ComposableArchitecture
import CoreUI

public struct DragyView: View {
    var store: StoreOf<Dragy>
    
    public init(store: StoreOf<Dragy>) {
        self.store = store
    }

    public var body: some View {
            ZStack {
                WithViewStore(store) { viewStore in
                    Color.blue
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            viewStore.send(.onAppear)
                        }
                }

                VStack(alignment: .center, spacing: 12) {
                    rpmProgressView
                        .padding(.top, 12)
                    Spacer()
                    
                    HStack {
                        infoList

                        Spacer()


                        HStack {
                            VStack {
                                speedView
                                boostView
                            }
                            VStack {
                                isRaceOnView
                                dragyTypeView
                            }
                        }
                    }
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
                        .background(.blue)
                        .offset(y: -10)
                }
                .padding()
            
        }
    }

    var isRaceOnView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .padding()
                .overlay(alignment: .top) {
                    if viewStore.state.isDragyOn {
                        Text("Stop")
                            .font(.title3)
                            .padding(.horizontal, 8)
                            .foregroundColor(.red)
                            .background(.blue)
                            .offset(y: -10)
                            .padding()
                    } else {
                        Text("Start")
                            .font(.title3)
                            .padding(.horizontal, 8)
                            .foregroundColor(.white)
                            .background(.blue)
                            .offset(y: -10)
                            .padding()
                    }
                    
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
                                $0.foregroundStyle(viewStore.state.isDragyOn ? .pink : .white, .green)
                            },
                            elseTransform: { $0.foregroundColor(.red)
                            }
                        )
                        .padding(20)
                        .onTapGesture {
                            viewStore.send(.draggyButtonTapped(!viewStore.state.isDragyOn))
                        }
                )
        }


    }

    var gearView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .overlay(
                    Text(viewStore.state.model.gear == 0 ? "R" : viewStore.state.model.gear == 11 ? "N" : String(viewStore.state.model.gear))
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
                .padding()
        }
    }

    var infoList: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .foregroundColor(.white.opacity(0.4))
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        ForEach(viewStore.timeList.keys.sorted(), id: \.self) { key in
                            if let value = viewStore.timeList[key] {
                                HStack {
                                    Image(systemName: "clock")
                                    Text(value)
                                        .foregroundColor(.black)
                                        .font(.init(.system(size: 22)))
                                }
                                .padding([.top, .leading], 16)
                            }
                        }
                        Spacer(minLength: 1)
                    }
                    .padding(.top, 20)
                }
                .if(!viewStore.timeList.isEmpty) {
                    $0.overlay(alignment: .topTrailing) {
                        Button(
                            action: {
                                viewStore.send(.resetList)
                            }, label: {
                                Image(systemName: "trash.fill")
                            }
                        )
                        .foregroundColor(.red)
                        .padding([.top, .trailing], 8)
                    }
                    
                }
                .padding([.leading, .bottom])
                
        }
    }

    var speedView: some View {
        WithViewStore(store) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .overlay(alignment: .center) {
                    Text(String(viewStore.state.model.speed))
                        .foregroundColor(.white)
                        .font(.init(.system(size: 60)))
                    +
                    Text("km/h")
                        .foregroundColor(.white)
                        .font(.init(.system(size: 20)))
                }
                .overlay(alignment: .top) {
                    Text("S P E E D")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.blue)
                        .offset(y: -10)
                }
                .padding()

        }
    }
    
    var dragyTypeView: some View {
        WithViewStore(store.scope(state: \.dragyType)) { viewStore in
            Rectangle()
                .stroke(lineWidth: 3)
                .foregroundColor(.white)
                .overlay(alignment: .center) {
                    Picker(
                        "Choose dragy type",
                        selection: viewStore
                            .binding(
                                get: { $0.self },
                                send: { Dragy.Action.updateDragyType($0) }
                            )
                    ) {
                        ForEach(Dragy.State.DragyType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .font(.init(.system(size: 20)))
                                .foregroundColor(.white)
                        }
                    }
                    #if os(iOS)
                    .pickerStyle(WheelPickerStyle())
                    #endif
                    
                }
                .overlay(alignment: .top) {
                    Text("DRAGY TYPE")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(.blue)
                        .offset(y: -10)
                }
                .padding()

        }
    }
}

struct DragyView_Previews: PreviewProvider {
    static var previews: some View {
        DragyView(
            store: Store(
                initialState: Dragy.State(),
                reducer: Dragy()
            )
        )
            .previewInterfaceOrientation(.landscapeRight)
    }
}
