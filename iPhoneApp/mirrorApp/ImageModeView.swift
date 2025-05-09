import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

/// Image Mode – lets the user pick a photo, adjust brightness / contrast / invert
/// and preview the processed image in real-time.
struct ImageModeView: View {
    @EnvironmentObject private var state: MirrorControlState

    // MARK: - Image handling
    @State private var showingPhotoPicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?

    private let context = CIContext()
    private let colorControls = CIFilter.colorControls()
    private let invertFilter = CIFilter.colorInvert()

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 16) {
                    uploadCard
                    if let processedImage {
                        processedImageCard(image: processedImage)
                    }
                    processingControlsCard
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGray6))
        }
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker(image: $inputImage)
                .ignoresSafeArea()
        }
        // Updated for iOS 17+: use zero-parameter closures
        .onChange(of: inputImage) { applyProcessing() }
        .onChange(of: state.brightness) { applyProcessing() }
        .onChange(of: state.contrast) { applyProcessing() }
        .onChange(of: state.invertColors) { applyProcessing() }
    }

    // MARK: - Header
    private var header: some View {
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
    }

    // MARK: - Upload Card
    private var uploadCard: some View {
        VStack {
            VStack {
                Image(systemName: "arrow.up.doc.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                Text("Upload an Image")
                    .font(.headline)
                    .padding(.bottom, 2)
                Text("Pick a photo from your library")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                Button("Browse Photos") {
                    showingPhotoPicker = true
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
            }
            .padding(32)
            .frame(maxWidth: .infinity, minHeight: 250)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundColor(Color.gray.opacity(0.3))
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 1)
        .padding(.horizontal)
    }

    // MARK: - Processed Image Card
    private func processedImageCard(image: UIImage) -> some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 1)
        .padding(.horizontal)
    }

    // MARK: - Processing Controls
    private var processingControlsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Image Processing")
                .font(.headline)
                .padding(.bottom, 8)

            Group {
                Text("Brightness")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack {
                    Slider(value: $state.brightness, in: 0...200)
                    Text("\(Int(state.brightness))%")
                        .font(.caption)
                }
            }

            Group {
                Text("Contrast")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack {
                    Slider(value: $state.contrast, in: 0...200)
                    Text("\(Int(state.contrast))%")
                        .font(.caption)
                }
            }

            Toggle("Invert Colors", isOn: $state.invertColors)

            HStack {
                Spacer()
                Button("Reset") {
                    resetProcessing()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
                .disabled(inputImage == nil)

                Button("Project Image") {
                    // TODO: integrate with mirror projection pipeline
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
                .disabled(processedImage == nil)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 1)
        .padding(.horizontal)
    }

    // MARK: - Image Processing
    private func applyProcessing() {
        guard let inputImage else { return }
        var ciImage = CIImage(image: inputImage)
        let brightnessValue = (state.brightness - 100) / 100
        let contrastValue   = state.contrast / 100

        colorControls.inputImage = ciImage
        colorControls.brightness = Float(brightnessValue)
        colorControls.contrast   = Float(contrastValue)
        colorControls.saturation = 1.0

        ciImage = colorControls.outputImage

        if state.invertColors {
            invertFilter.inputImage = ciImage
            ciImage = invertFilter.outputImage
        }

        guard let ciImage,
              let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        processedImage = UIImage(cgImage: cgImage)
    }

    // MARK: - Reset Processing
    private func resetProcessing() {
        state.brightness = 100
        state.contrast = 100
        state.invertColors = false
        applyProcessing()
    }
}

// MARK: - PhotoPicker wrapper using PHPickerViewController
struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        init(_ parent: PhotoPicker) { self.parent = parent }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
