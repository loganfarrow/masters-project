import SwiftUI

/// A control panel that lets the user adjust the X‑ and Y‑axis motors of the selected mirrors.
/// The panel shows **only** when a `Region` *and* at least one mirror in that region are selected.
struct MirrorAngleControlsView: View {
    @EnvironmentObject private var state: MirrorControlState
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        // Render only when we really have something selected
        if state.selectedRegion != nil && !state.selectedMirrors.isEmpty {
            content
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 1)
                .padding(.horizontal)
        }
    }

    // MARK: - Main content
    @ViewBuilder private var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            Text("Mirror Angle Controls")
                .font(.headline)

            // Motor block
            motorSection

            // Sliders
            RotationSlider(title: "X‑Axis Rotation", angle: $state.xRotation)
            RotationSlider(title: "Y‑Axis Rotation", angle: $state.yRotation)

            // Bottom actions
            HStack {
                Button("Reset Selected", action: resetSelectedMirrors)
                    .buttonStyle(SecondaryButtonStyle())
                Spacer()
                Button("Apply to Selected", action: applyRotationToSelected)
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    // MARK: - Motor Section
    private var motorSection: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Text("Motor Controls")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Reset", action: resetMotors)
                    .buttonStyle(SecondaryButtonStyle())
                Button("Calibrate", action: calibrateMotors)
                    .buttonStyle(SecondaryButtonStyle())
            }

            // Adaptive layout for the two dials
            if sizeClass == .compact {
                VStack(spacing: 24) {
                    DialView(angle: state.xRotation, label: "X‑Motor")
                    DialView(angle: state.yRotation, label: "Y‑Motor")
                }
            } else {
                HStack(spacing: 32) {
                    DialView(angle: state.xRotation, label: "X‑Motor")
                    DialView(angle: state.yRotation, label: "Y‑Motor")
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }

    // MARK: - Actions (stubs)
    private func resetMotors() {
        state.xRotation = 0
        state.yRotation = 0
    }

    private func calibrateMotors() {
        // TODO: Implement calibration logic
    }

    private func resetSelectedMirrors() {
        state.resetSelectedMirrors()
    }

    private func applyRotationToSelected() {
        // TODO: Send rotation values to hardware for mirrors in `selectedMirrors`
    }
}

// MARK: - Dial View
struct DialView: View {
    let angle: Double
    let label: String
    @Environment(\.horizontalSizeClass) private var sizeClass

    // Dial scales down on compact devices to avoid horizontal clipping
    private var dialSize: CGFloat { sizeClass == .compact ? 120 : 160 }

    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(Color.white.opacity(0.85), lineWidth: dialSize * 0.15)
                .frame(width: dialSize, height: dialSize)

            // Inner face
            Circle()
                .fill(Color(UIColor.systemGray4))
                .frame(width: dialSize * 0.66, height: dialSize * 0.66)

            // Needle
            Rectangle()
                .fill(Color.blue)
                .frame(width: 4, height: dialSize * 0.34)
                .offset(y: -dialSize * 0.17)
                .rotationEffect(.degrees(angle))
                .animation(.easeInOut(duration: 0.2), value: angle)

            // Label
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Slider with labels
struct RotationSlider: View {
    let title: String
    @Binding var angle: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(title) (0–360º)")
                .font(.subheadline)
            HStack {
                Text("0º").font(.caption)
                Slider(value: $angle, in: 0...360, step: 1)
                Text("360º").font(.caption)
                // Live angle read‑out
                Text("\(Int(angle))º")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 48, alignment: .trailing)
            }
        }
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(6)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.15))
            .foregroundColor(.blue)
            .cornerRadius(6)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
