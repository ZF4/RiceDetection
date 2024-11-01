//
//  AddPhoto.swift
//  RiceDetection
//
//  Created by Zachary Farmer on 10/8/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddPhoto: View {
    @Environment(\.modelContext) var modelContext
    @State private var image: UIImage?
//    @State var post = PostModel()
    @State private var isConfirmationDialogPresented: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var sourceType: SourceType = .camera
    @Binding var selectedPhoto: UIImage?
    
    enum SourceType {
        case camera
        case photoLibrary
    }
    
    var body: some View {
        Button(action: {
            isConfirmationDialogPresented = true
        }, label: {
            if let image = selectedPhoto {
                SelectedImageView(image: image)
            } else {
                PlaceholderView()
            }
        })
        .confirmationDialog("Choose an option", isPresented: $isConfirmationDialogPresented) {
            Button("Camera") {
                sourceType = .camera
                isImagePickerPresented = true
            }
            Button("Photo Library") {
                sourceType = .photoLibrary
                isImagePickerPresented = true
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            if sourceType == .camera {
                ImagePicker(isPresented: $isImagePickerPresented, image: $selectedPhoto, sourceType: .camera)
            } else {
                PhotoPicker(selectedImage: $selectedPhoto)
            }
        }
    }
}

struct SelectedImageView: View {
    var image: UIImage
    var width = UIScreen.main.bounds.width - 50
    var height = UIScreen.main.bounds.height
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: width, height: 300)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct PlaceholderView: View {
    var body: some View {
        ZStack {
            Image(systemName: "photo.badge.plus.fill")
                .font(.system(size: 90))
                .foregroundStyle(Color.black.opacity(0.7))
            
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10), style: .continuous)
                .foregroundStyle(Color.gray.opacity(0.2))
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let uiImage = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = uiImage
                        }
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> some PHPickerViewController {
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

#Preview {
    AddPhoto(selectedPhoto: .constant(UIImage(named: "placeholderImage")))
}
