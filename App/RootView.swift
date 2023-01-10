import Foundation
import DashFeature
import SwiftUI

struct RootView: View {
    var body: some View {
        DashView(store: .init(initialState: Dash.State(model: .init()), reducer: Dash()))
    }
    
}
