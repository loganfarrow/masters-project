import Foundation
import SwiftUI

// Model for mirror regions
struct Region: Identifiable {
    var id: String
    var label: String
    var rows: Int
    var cols: Int
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
}

// Model definition for the app state
class MirrorControlState: ObservableObject {
    @Published var activeTab: Tab = .individual
    @Published var selectedRegion: Region?
    @Published var selectedMirrors: Set<Int> = []
    @Published var xRotation: Double = 45
    @Published var yRotation: Double = 90
    @Published var brightness: Double = 100
    @Published var contrast: Double = 100
    @Published var invertColors: Bool = false
    
    // Define window regions
    let regions: [Region] = [
        // Top row - 6 small regions (5x8 each)
        Region(id: "top1", label: "Top Left 1", rows: 5, cols: 8, x: 0, y: 0, width: 16.6, height: 30),
        Region(id: "top2", label: "Top Left 2", rows: 5, cols: 8, x: 16.6, y: 0, width: 16.6, height: 30),
        Region(id: "top3", label: "Top Left 3", rows: 5, cols: 8, x: 33.2, y: 0, width: 16.6, height: 30),
        Region(id: "top4", label: "Top Right 1", rows: 5, cols: 8, x: 50, y: 0, width: 16.6, height: 30),
        Region(id: "top5", label: "Top Right 2", rows: 5, cols: 8, x: 66.6, y: 0, width: 16.6, height: 30),
        Region(id: "top6", label: "Top Right 3", rows: 5, cols: 8, x: 83.2, y: 0, width: 16.6, height: 30),
        
        // Bottom row - 4 larger regions (8x11 each) with gap for door
        Region(id: "bottom1", label: "Bottom Left 1", rows: 8, cols: 11, x: 0, y: 35, width: 22, height: 65),
        Region(id: "bottom2", label: "Bottom Left 2", rows: 8, cols: 11, x: 22, y: 35, width: 22, height: 65),
        Region(id: "bottom3", label: "Bottom Right 1", rows: 8, cols: 11, x: 56, y: 35, width: 22, height: 65),
        Region(id: "bottom4", label: "Bottom Right 2", rows: 8, cols: 11, x: 78, y: 35, width: 22, height: 65),
    ]
    
    // Toggle mirror selection
    func toggleMirrorSelection(_ mirrorId: Int) {
        if selectedMirrors.contains(mirrorId) {
            selectedMirrors.remove(mirrorId)
        } else {
            selectedMirrors.insert(mirrorId)
        }
    }
    
    // Reset selected mirrors
    func resetSelectedMirrors() {
        selectedMirrors = []
    }
}

// Tab enum for the tab selection
enum Tab {
    case individual
    case image
    case patterns
    
    var title: String {
        switch self {
        case .individual: return "Mirror Control"
        case .image: return "Image Mode"
        case .patterns: return "Patterns"
        }
    }
}

// Define patterns for pattern mode
struct Pattern: Identifiable {
    var id: String
    var name: String
}

// Sample patterns
let samplePatterns = [
    Pattern(id: "wave", name: "Wave"),
    Pattern(id: "ripple", name: "Ripple"),
    Pattern(id: "spiral", name: "Spiral"),
    Pattern(id: "random", name: "Random"),
    Pattern(id: "checkerboard", name: "Checkerboard"),
    Pattern(id: "gradient", name: "Gradient")
]
