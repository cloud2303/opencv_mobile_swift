//
//  ContentView.swift
//  cvios
//
//  Created by fujiahui on 2024/5/25.
//

import SwiftUI
import PhotosUI
class ImagePickerViewModel: ObservableObject {
    @Published var imageState: UIImage? = UIImage(named: "example.jpg")
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            loadSelectedImage()
        }
    }

    private func loadSelectedImage() {
        guard let imageSelection = imageSelection else { return }

        imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data?):
                    if let uiImage = UIImage(data: data) {
                        self.imageState = uiImage
                    }
                case .success(nil):
                    print("No image data found")
                case .failure(let error):
                    print("Failed to load image data: \(error.localizedDescription)")
                }
            }
        }
    }
}
struct ContentView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
       @State private var processedImageBase64: String = ""
       @State private var processedImage: UIImage?

       var body: some View {
           VStack {
               if let imageState = viewModel.imageState {
                   Image(uiImage: imageState)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 300, height: 300)
                       .padding(.bottom, 20)
               }

               if let processedImage = processedImage {
                   Image(uiImage: processedImage)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 300, height: 300)
                       .padding(.bottom, 20)
               }

               HStack {
                   PhotosPicker(selection: $viewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
                       Image(systemName: "photo.on.rectangle")
                           .font(.system(size: 30))
                           .foregroundColor(.accentColor)
                   }
                   .buttonStyle(.borderless)
                   
                   Button(action: {
                       if let imageState = viewModel.imageState, let imageData = imageState.pngData() {
                           let originalImageBase64 = imageData.base64EncodedString()
                           processedImageBase64 = cvHelper.processImage(originalImageBase64)
                           if let processedImageData = Data(base64Encoded: processedImageBase64) {
                               processedImage = UIImage(data: processedImageData)
                           }
                       }
                   }) {
                       Text("Process Image")
                           .padding()
                           .background(Color.blue)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                   }
               }
           }
           .padding()
       }
}

#Preview {
    ContentView()
}
