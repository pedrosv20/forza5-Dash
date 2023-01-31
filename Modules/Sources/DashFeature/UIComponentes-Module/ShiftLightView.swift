import Foundation
import SwiftUI

struct ShiftLightView: View {
    @State private var blinkColor: Color = .black
    var fractionCompleted: Double?
    var width: CGFloat
    var backgroundColor: Color = .black
    
    var body: some View {
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
