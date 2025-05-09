import SwiftUI

struct ContentView: View {
    @StateObject private var state = MirrorControlState()
    
    var body: some View {
        TabView(selection: $state.activeTab) {
            // MARK: – Mirror Control Tab
            VStack(spacing: 0) {
                // Header
                ZStack {
                    Color.blue
                    HStack {
                        Text("Mirror Array Control")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.trailing)
                    }
                }
                .frame(height: 60)
                
                // Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Status Bar
                        HStack {
                            if let region = state.selectedRegion {
                                Text("\(region.label) Selected – \(state.selectedMirrors.count) of \(region.rows * region.cols) mirrors selected")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Select a region on the window")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            HStack(spacing: 15) {
                                // Example control buttons (customize actions)
                                Button { /* grid action */ } label: {
                                    Image(systemName: "square.grid.3x3.fill")
                                }
                                Button { /* reset action */ } label: {
                                    Image(systemName: "arrow.counterclockwise")
                                }
                                Button { /* save action */ } label: {
                                    Image(systemName: "square.and.arrow.down")
                                }
                            }
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(height: 40)
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        
                        // Window Layout Card
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Window Layout – Select a Region")
                                .font(.headline)
                                .padding(.leading)
                                .padding(.top)
                            
                            WindowLayoutView()
                                .frame(height: 200)
                                .padding([.horizontal, .bottom])
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 1)
                        .padding(.horizontal)
                        
                        // Individual Mirror Grid Card
                        if let selectedRegion = state.selectedRegion {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(selectedRegion.label) – Individual Mirrors")
                                    .font(.headline)
                                    .padding(.leading)
                                    .padding(.top)
                                
                                MirrorGridView(region: selectedRegion)
                                    .padding([.horizontal, .bottom])
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 1)
                            .padding(.horizontal)
                        }
                        
                        // Mirror Angle Controls Card
                        // Only shown when a region AND at least one mirror are selected
                        if state.selectedRegion != nil && !state.selectedMirrors.isEmpty {
                            MirrorAngleControlsView()
                                .environmentObject(state)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(Color(.systemGray6))
            }
            .tabItem {
                Image(systemName: "square.grid.3x3.fill")
                Text("Mirror Control")
            }
            .tag(Tab.individual)
            
            // MARK: – Image Mode Tab
            ImageModeView()
                .tabItem {
                    Image(systemName: "photo.fill")
                    Text("Image Mode")
                }
                .tag(Tab.image)
            
            // MARK: – Patterns Tab
            ChairLightingView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Request Seat Lighting")
                }
                .tag(Tab.patterns)   // keeps the enum the same

        }
        .accentColor(.blue)
        .environmentObject(state)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
