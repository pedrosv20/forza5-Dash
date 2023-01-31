import CoreUI
import DashFeature
import Foundation
import SwiftUI

enum AppContext: Equatable {
    case dragy
    case dash
}

struct RootView: View {
    @State var appContext: AppContext = .dash

    var body: some View {
        currentView()
            .animation(.linear, value: appContext)
            .addThreeTapGesture {
                withAnimation {
                    toggleContext()
                }
            }
    }
    
    @ViewBuilder
    func currentView() -> some View {
        switch appContext {
        case .dragy:
            DragyView(store: .init(initialState: Dragy.State(), reducer: Dragy()))
        case .dash:
            DashView(store: .init(initialState: Dash.State(), reducer: Dash()))
        }
    }
    
    
    func toggleContext() {
        switch appContext {
        case .dragy:
            appContext = .dash
        case .dash:
            appContext = .dragy
        }
    }
}
