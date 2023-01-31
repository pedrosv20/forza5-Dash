import Foundation
import SwiftUI

public extension View {
    func simpleRPMProgressStyle() -> some View {
        self.progressViewStyle(SimpleRPMProgressViewStyle())
    }
}


struct SimpleRPMProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { gProxy in
            ZStack {
                Rectangle()
                    .stroke(lineWidth: 3)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(alignment: .leading) {
                        Color.red
                            .frame(
                                width: CGFloat(configuration.fractionCompleted ?? 0) * gProxy.size.width
                            )
                    }
            }
        }
    }
}
