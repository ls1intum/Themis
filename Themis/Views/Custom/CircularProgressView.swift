import Foundation
import SwiftUI

enum StatisticDescription {
    case participationRate, assessed, averageScore
}

struct CircularProgressView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var defaultValue: Double = 0.0
    var progress: Double = 0.0
    var description: StatisticDescription
    
    private let ringRadius = 90.0
    private let lineWidth = 30.0
    
    private func statDesc() -> String {
        switch description {
        case .participationRate: return "Participation Rate"
        case .assessed: return "Assessed"
        case .averageScore: return "Average Score"
        }
    }
    
    private func percentToAngle(startAngle: Double) -> Double {
        (progress * 360) + startAngle
    }
    
    private func gradientColor() -> Gradient {
        switch progress {
        case ...0.33:
            return Gradient(colors: [.themisDarkRed, Color.red])
            
        case 0.33..<0.79:
            return Gradient(colors: [Color.orange, Color.yellow])
            
        case 0.79...:
            return Gradient(colors: [Color.green, .themisGreen])
            
        default:
            return Gradient(colors: [Color.clear])
        }
    }
    
    private func createGradient() -> AngularGradient {
        AngularGradient(
            gradient: gradientColor(),
            center: .center,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360.0 * progress)
        )
    }
    
    private var ringTipShadowOffset: CGPoint {
        let ringTipPosition = tipPosition(progress: progress, radius: ringRadius)
        let shadowPosition = tipPosition(progress: progress + 0.005, radius: ringRadius)
        return CGPoint(x: shadowPosition.x - ringTipPosition.x,
                       y: shadowPosition.y - ringTipPosition.y)
    }
    
    private func tipPosition(progress: Double, radius: Double) -> CGPoint {
        let progressAngle = Angle(degrees: (360.0 * progress) - 90.0)
        return CGPoint(
            x: radius * cos(progressAngle.radians),
            y: radius * sin(progressAngle.radians))
    }
            
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: lineWidth)
                    .opacity(0.1)
                    .foregroundColor(.gray)
                    .frame(width: ringRadius * 2.0)

                Circle()
                    .trim(from: 0.0, to: defaultValue)
                    .stroke(createGradient(), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(Angle(degrees: -90.0))
                    .frame(width: ringRadius * 2.0)

                CircularProgressViewRingTip(progress: defaultValue, ringRadius: Double(ringRadius))
                    .fill(defaultValue > 0.95 ? gradientColor().stops.last?.color ?? .white : .clear)
                    .frame(width: lineWidth, height: lineWidth)
                    .shadow(color: progress > 0.95 ? .black.opacity(0.1) : .clear,
                            radius: 0.05,
                            x: ringTipShadowOffset.x,
                            y: ringTipShadowOffset.y
                    )
                
                Text(progress.isFinite && !progress.isNaN ? "\(Int(progress * 100.0))%" : "N/A")
                    .font(.system(size: 35))
            }
            .padding(25)
            
            Text(statDesc())
                .font(.system(size: 20))
                .bold()
                .padding(5)
        }
        .scaledToFit()
        .frame(minWidth: 240, maxWidth: 300, minHeight: 240, maxHeight: 300)
        .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
        .cornerRadius(20)
        .shadow(radius: 0.2)
        .onAppear {
            withAnimation(.linear(duration: 1.0)) {
                self.defaultValue = progress
            }
        }
    }
}

 struct CircularProgressViewRingTip: Shape {
    var progress: Double
    var ringRadius: Double

    private var position: CGPoint {
        let progressAngle = Angle(degrees: (360.0 * progress) - 90.0)
        return CGPoint(
            x: ringRadius * cos(progressAngle.radians),
            y: ringRadius * sin(progressAngle.radians))
    }

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if progress > 0.0 {
            path.addEllipse(in: CGRect(
                                x: position.x,
                                y: position.y,
                                width: rect.size.width,
                                height: rect.size.height))
        }
        return path
    }
 }
    
struct CircularProgressViewPreview: PreviewProvider {
    static var previews: some View {
        HStack {
            CircularProgressView(progress: 0.3, description: .participationRate)
            CircularProgressView(progress: 0.6, description: .assessed)
            CircularProgressView(progress: 1.2, description: .averageScore)
        }
    }
}
