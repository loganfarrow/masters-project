import SwiftUI

/// A top-down room view with six chairs along the side walls.
/// Tapping a chair sends a light beam from the mirror wall (top center)
/// at a diagonal, and shows an animated halo around the chair.
struct ChairLightingView: View {
    // Track which chairs are lit
    @State private var litChairs: Set<Int> = []

    // Simple chair model: positions in unit coordinates (0…1)
    private struct Chair: Identifiable {
        let id: Int
        let position: CGPoint
    }

    // Six chairs: three on left wall, three on right, evenly spaced vertically
    private let chairs: [Chair] = [
        Chair(id: 0, position: CGPoint(x: 0.1, y: 0.25)),
        Chair(id: 1, position: CGPoint(x: 0.1, y: 0.50)),
        Chair(id: 2, position: CGPoint(x: 0.1, y: 0.75)),
        Chair(id: 3, position: CGPoint(x: 0.9, y: 0.25)),
        Chair(id: 4, position: CGPoint(x: 0.9, y: 0.50)),
        Chair(id: 5, position: CGPoint(x: 0.9, y: 0.75))
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            GeometryReader { geo in
                let topPadding: CGFloat = 20
                let mirrorHeight: CGFloat = 20
                let mirrorCenter = CGPoint(
                    x: geo.size.width / 2,
                    y: topPadding + mirrorHeight / 2
                )

                ZStack {
                    // Room background and outline, fills all space under header
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 2)
                        )

                    // Mirror wall at top, with padding from top of room
                    Rectangle()
                        .fill(Color.blue.opacity(0.4))
                        .frame(height: mirrorHeight)
                        .overlay(
                            Text("Mirror Wall")
                                .font(.caption2)
                                .foregroundColor(.white)
                        )
                        .position(
                            x: geo.size.width / 2,
                            y: topPadding + mirrorHeight / 2
                        )

                    // Light beams
                    ForEach(chairs) { chair in
                        if litChairs.contains(chair.id) {
                            Path { path in
                                let chairPoint = CGPoint(
                                    x: chair.position.x * geo.size.width,
                                    y: chair.position.y * geo.size.height
                                )
                                path.move(to: mirrorCenter)
                                path.addLine(to: chairPoint)
                            }
                            .stroke(
                                Color.yellow.opacity(0.6),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .animation(.easeInOut(duration: 0.3), value: litChairs)
                        }
                    }

                    // Chairs with endpoints along side walls
                    ForEach(chairs) { chair in
                        let center = CGPoint(
                            x: chair.position.x * geo.size.width,
                            y: chair.position.y * geo.size.height
                        )
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                if litChairs.contains(chair.id) {
                                    litChairs.remove(chair.id)
                                } else {
                                    litChairs.insert(chair.id)
                                }
                            }
                        }) {
                            ZStack {
                                // Halo animation
                                if litChairs.contains(chair.id) {
                                    Circle()
                                        .fill(Color.yellow.opacity(0.3))
                                        .frame(width: 100, height: 100)
                                        .scaleEffect(1)
                                        .animation(.easeOut(duration: 0.35), value: litChairs)
                                }
                                Image(systemName: "chair.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.brown)
                            }
                        }
                        .position(center)
                    }
                }
                // Respect safe areas at bottom so TabView remains visible
                .padding(.bottom, geo.safeAreaInsets.bottom)
                .padding(.top, 0) // no ignore on top
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    // Header bar pinned below the status bar
    private var header: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.top)
            HStack {
                Text("Seat Lighting")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)
                Spacer()
            }
        }
        .frame(height: 60)
    }
}

struct ChairLightingView_Previews: PreviewProvider {
    static var previews: some View {
        ChairLightingView()
    }
}
