import SwiftUI

// Mirror grid view
struct MirrorGridView: View {
    @EnvironmentObject private var state: MirrorControlState
    let region: Region
    
    var body: some View {
        // Use a LazyVGrid with proper spacing for the mirrors
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: region.cols)
        
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<(region.rows * region.cols), id: \.self) { index in
                Circle()
                    .stroke(Color.gray, lineWidth: 0.5)
                    .background(
                        Circle()
                            .fill(state.selectedMirrors.contains(index) ?
                                  Color.blue.opacity(0.3) :
                                  Color.gray.opacity(0.1))
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        state.toggleMirrorSelection(index)
                    }
            }
        }
        .padding(.vertical, 8)
    }
}

// Patterns Mode View
struct PatternsModeView: View {
    @EnvironmentObject private var state: MirrorControlState
    
    var body: some View {
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
                    // Patterns library
                    VStack(alignment: .leading) {
                        Text("Pattern Library")
                            .font(.headline)
                            .padding([.leading, .top])
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                            ForEach(samplePatterns) { pattern in
                                VStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 80)
                                        .cornerRadius(4)
                                    
                                    Text(pattern.name)
                                        .font(.caption)
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                            
                            // Create new button
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(height: 80)
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 24))
                                        .foregroundColor(.gray)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
                                        .foregroundColor(Color.gray.opacity(0.3))
                                )
                                
                                Text("Create New")
                                    .font(.caption)
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 1)
                    .padding(.horizontal)
                    
                    // Pattern editor
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Pattern Editor")
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Button(action: {}) {
                                    Image(systemName: "pencil")
                                        .padding(6)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: {}) {
                                    Image(systemName: "play.fill")
                                        .padding(6)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.down")
                                        .padding(6)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .padding(.bottom, 8)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                                .frame(height: 200)
                            
                            Text("Select a pattern to edit or create a new one")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 1)
                    .padding(.horizontal)
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGray6))
        }
    }
}
