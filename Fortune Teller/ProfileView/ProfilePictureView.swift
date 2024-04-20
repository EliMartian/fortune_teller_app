//
//  ProfilePictureView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/20/24.
//



import Foundation
import SwiftUI
import UIKit

struct ProfilePictureView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ProfilePictureViewModel()
    @State private var isShowingImagePicker = false

    var body: some View {
        VStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
            }

            Button(action: {
                isShowingImagePicker.toggle()
            }) {
                Text("Select Image")
            }
            .padding()
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(isPresented: $isShowingImagePicker, selectedImage: $viewModel.selectedImage)
            }
        }
        .navigationBarBackButtonHidden(true)
        // Use a custom back button
        .navigationBarItems(leading: backButton)
    }

    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.green)
                .imageScale(.medium)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update needed, generic placeholder
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(isPresented: .constant(true), selectedImage: .constant(nil))
    }
}


struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}


class ProfilePictureViewModel: ObservableObject {
    @Published var selectedImage: UIImage? {
        didSet {
            saveSelectedImage()
        }
    }
    
    private let selectedImageFilename = "selectedImage.jpg"
    
    init() {
        loadSelectedImage()
    }
    
    private func saveSelectedImage() {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 1.0),
              let imageURL = imageURL else {
            return
        }
        
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("Error saving image data: \(error.localizedDescription)")
        }
    }
    
    private func loadSelectedImage() {
        guard let imageURL = imageURL,
              FileManager.default.fileExists(atPath: imageURL.path),
              let imageData = try? Data(contentsOf: imageURL),
              let loadedImage = UIImage(data: imageData) else {
            return
        }
        selectedImage = loadedImage
    }
    
    private var imageURL: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(selectedImageFilename)
    }
}
