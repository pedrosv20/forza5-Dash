import Foundation
import SwiftUI

public extension View {
    func threeColorProgressStyle() -> some View {
        self.progressViewStyle(ThreeColorRPMProgressViewStyle())
    }
}

struct ThreeColorRPMProgressViewStyle: ProgressViewStyle {
    @State var blinkColor: Color = .clear

    func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { gProxy in
            ZStack(alignment: .leading) {
                mainRPMRectanglesView(configuration, width: gProxy.size.width)
                
                ShiftLightView(
                    width: gProxy.size.width,
                    fractionCompleted: configuration.fractionCompleted
                )
            }
        }
    }

    func mainRPMRectanglesView(_ configuration: Configuration, width: CGFloat) -> some View {
        HStack(spacing: .zero) {
            Rectangle()
                .foregroundColor(.green)
                
                .frame(
                    width: calculateRectangleSize(1, completedPercentage: configuration.fractionCompleted, maxWidth: width),
                    height: 60
                )

            Rectangle()
                .foregroundColor(.yellow)
                .frame(
                    width: calculateRectangleSize(2, completedPercentage: configuration.fractionCompleted, maxWidth: width),
                    height: 60
                )
            
            Rectangle()
                .foregroundColor(.red)
                .frame(
                    width: calculateRectangleSize(3, completedPercentage: configuration.fractionCompleted, maxWidth: width),
                    height: 60
                )
            
        }
    }
}

extension ThreeColorRPMProgressViewStyle {
    func calculateRectangleSize(
        _ rectangle: Int,
        completedPercentage: Double?,
        maxWidth: Double
    ) -> CGFloat {
        guard let completedPercentage else { return 0 }
        switch rectangle {
        case 1:
            if completedPercentage <= 0.33 {
                return completedPercentage * maxWidth
            } else {
                return maxWidth * 0.33
            }
        case 2:
            if completedPercentage > 0.33, completedPercentage <= 0.66  {
                return completedPercentage.truncatingRemainder(dividingBy: 0.33) * maxWidth
            } else if completedPercentage > 0.66 {
                return maxWidth * 0.33
            } else  {
                return 0
            }
            
        case 3:
            if completedPercentage > 0.66 {
                return completedPercentage.truncatingRemainder(dividingBy: 0.33) * maxWidth
            } else {
                return 0
            }
        default:
            return 0
        }
    }
}


