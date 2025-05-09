//
//  WindowLayoutView.swift
//  mirrorApp
//
//  Created by Logan Farrow on 4/25/25.
//


import SwiftUI

struct WindowLayoutView: View {
    @EnvironmentObject private var state: MirrorControlState

    var body: some View {
        VStack(spacing: 8) {
            // Top row – 6 regions
            HStack(spacing: 8) {
                ForEach(state.regions.prefix(6)) { region in
                    regionButton(for: region)
                }
            }

            // Bottom row – 2 regions, door gap, 2 regions
            HStack(spacing: 8) {
                ForEach(state.regions[6...7]) { region in
                    regionButton(for: region)
                }

                Spacer(minLength: 28) // Door gap – adjust width as needed

                ForEach(state.regions[8...9]) { region in
                    regionButton(for: region)
                }
            }
        }
        .padding()
        .background(Color(red: 0.3, green: 0.4, blue: 0.6))
        .cornerRadius(8)
    }

    // MARK: - Helpers
    private func regionButton(for region: Region) -> some View {
        Button(action: {
            state.selectedRegion = region
            state.resetSelectedMirrors()
        }) {
            Text(region.label)
                .font(.caption2)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(4)
                .background(state.selectedRegion?.id == region.id ? Color.blue : Color.white)
                .foregroundColor(state.selectedRegion?.id == region.id ? .white : .black)
                .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }
}
