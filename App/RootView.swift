import CoreUI
import DashFeature
import DragyFeature
import GForceFeature
import Foundation
import SwiftUI

enum AppContext: Equatable {
    case dragy
    case dash
    case gForce
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
            // GENERIC
        case .dragy:
            DragyView(store: .init(
                initialState: Dragy.State(),
                reducer: Dragy())
            )
        case .dash:
            DashView(store: .init(
                initialState: Dash.State(),
                reducer: Dash())
            )
        case .gForce:
            GForceView(store: .init(
                initialState: GForce.State(),
                reducer: GForce()
                )
            )
        }
    }
    
    
    func toggleContext() {
        switch appContext {
        case .dragy:
            appContext = .gForce
        case .dash:
            appContext = .dragy
        case .gForce:
            appContext = .dash
        }
    }
}
