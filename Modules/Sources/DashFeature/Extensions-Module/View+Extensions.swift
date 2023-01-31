import Foundation
import SwiftUI

public extension View {
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
