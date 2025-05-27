import SwiftUI

struct ProgressBar: View {
    var progress: Double // 0.0〜1.0
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 12)
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: geo.size.width * CGFloat(progress), height: 12)
            }
        }
        .frame(height: 12)
        .animation(.easeInOut, value: progress)
    }
} 