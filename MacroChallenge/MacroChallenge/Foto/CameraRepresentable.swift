//
//  CameraRepresentable.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Rodrigo Ferreira Pereira on 25/05/23.
//

import AVFoundation
import SwiftUI

struct CameraRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    @Binding var capturedImages: [UIImage]

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator // Definindo o delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // Definindo o coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraRepresentable

        init(parent: CameraRepresentable) {
            self.parent = parent
        }

        // Método chamado quando a imagem é capturada
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImages.append(image) // Adicionando a imagem capturada ao array capturedImages
                let photoModel = PhotoModel(name: "", creationDate: Date(), modifiedDate: Date(), capturedImages: parent.capturedImages)
                IdeaSaver.savePhotoIdea(idea: photoModel)
            }

            picker.dismiss(animated: true) // Fechando a câmera
        }

        // Método chamado quando o usuário cancela a captura
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) // Fechando a câmera
        }
    }
}
