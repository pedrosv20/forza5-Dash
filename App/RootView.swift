import Foundation
import DashFeature
import SwiftUI

enum AppContext: Equatable {
    case dragy
    case dash
}

struct RootView: View {
    @State var appContext: AppContext = .dash

    var body: some View {
        currentView()
            .animation(.easeInOut, value: appContext)
            .addThreeTapGesture {
                toggleContext()
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

extension View {
    func addThreeTapGesture(action: @escaping () -> Void) -> some View {
        self.modifier(ThreeTapGestureModifier(action: action))
    }
}

struct ThreeTapGestureModifier: ViewModifier {
    var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.gesture(TapGesture(count: 3).onEnded {
            action()
        })
    }
}

// Rectangle list or indexes list 0 - 1/3 green, 1/3 - 2/3 yellow, 2/3 - 3/3 red
