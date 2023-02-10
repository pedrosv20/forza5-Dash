import Foundation
import SwiftUI

public extension View {
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
