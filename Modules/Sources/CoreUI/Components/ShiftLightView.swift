import Foundation
import SwiftUI

public struct ShiftLightView: View {
    @State private var blinkColor: Color = .clear
    var backgroundColor: Color = .black

    var width: CGFloat
    var fractionCompleted: Double?
    
    
    public var body: some View {
        Rectangle()
            .stroke(lineWidth: 3)
            .fill(.white)
            .frame(width: width, height: 60)
            .background(blinkColor)
            .onChange(of: fractionCompleted ?? 0, perform: { value in
                if value > 0.87 {
                    blinkColor = blinkColor == .red ? backgroundColor : .red
                } else {
                    blinkColor = .clear
                }
            })
    }
}
