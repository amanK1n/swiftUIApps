//
//  File9.swift
//  pracAppSun
//
//  Created by comviva on 04/10/26.
//

import SwiftUI

struct File9: View {
    @State private var currentImage: UIImage = UIImage(named: "placeholder") ?? UIImage()
    @State private var showPhotoLibrary: Bool = false
    @State private var shareSheet: Bool = false
    var body: some View {
        VStack {
            Image(uiImage: currentImage)
                .resizable()
                .scaledToFit()
            HStack {
                Button("Select Image") {
                    self.showPhotoLibrary.toggle()
                }
                .sheet(isPresented: $showPhotoLibrary) {
                    ImagePicker(selectedImage: $currentImage, sourceType: .photoLibrary)
                }
                Spacer()
                Button("Share Image") {
                    shareSheet.toggle()
                }
                .sheet(isPresented: $shareSheet) {
                    ShareSheet(contents: [currentImage])
                }
            }
            Spacer()
        }.padding()
    }
}

//--------------------------------=================Image Picker Impln

struct ImagePicker: UIViewControllerRepresentable {
   
    @Binding var selectedImage : UIImage
    
    typealias UIViewControllerType = UIImagePickerController
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
       // let parent: ImagePicker
        @Binding var selectedImgValue: UIImage
        init(selectedImgValue: Binding<UIImage>) {
            _selectedImgValue = selectedImgValue
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let userSelectedImage = info[.originalImage] as? UIImage {
                selectedImgValue = userSelectedImage
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImgValue: $selectedImage)
    }
    
}

//----------------------SHARE

struct ShareSheet: UIViewControllerRepresentable {
   
    var contents: [Any] = []
    typealias UIViewControllerType = UIActivityViewController
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: contents, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
}
