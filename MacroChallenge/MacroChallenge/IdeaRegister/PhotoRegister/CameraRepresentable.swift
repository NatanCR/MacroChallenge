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
    
    @ObservedObject var viewModel: CameraViewModel
    @StateObject var ideasViewModel: IdeasViewModel = IdeasViewModel()
    @Environment(\.dismiss) var dismiss
    @State var firstPermission: Bool = true
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator // Definindo o delegate
        
        viewModel.checkCameraPermission { granted in
            if granted {
                DispatchQueue.main.async {
                    ideasViewModel.isShowingCamera = true
                }
            } else {
//                print(firstPermission)
//                if firstPermission {
//                    DispatchQueue.main.async {
//                        dismiss()
//                        firstPermission = false
//                    }
//                } else {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        let alert = UIAlertController(title: "Permissão negada", message: "Você negou permissão para acessar a câmera. Deseja abrir as configurações para conceder permissão?", preferredStyle: .alert)
                        
                        //Obtém a cena de janela ativa
                        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            let window = UIWindow(windowScene: windowScene)
                            window.rootViewController = UIViewController()
                            window.windowLevel = UIWindow.Level.alert + 1
                            window.makeKeyAndVisible()
                            window.rootViewController?.present(alert, animated: true, completion: nil)
                            
                            alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { _ in
                                window.rootViewController?.dismiss(animated: true, completion: nil)
                                dismiss()
                            }))
                            alert.addAction(UIAlertAction(title: "Abrir configurações", style: .cancel, handler: { _ in
                                window.rootViewController?.dismiss(animated: true, completion: nil)
                                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                            }))
                        }
                    }
                }
//            }
        }
        
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
            guard let image = info[.originalImage] as? UIImage else {
                picker.dismiss(animated: true) // Fechando a câmera
                return
            }
            
            do {
                try parent.viewModel.captureImage(image: image) // Chama o método captureImage do ViewModel
                
            } catch {
                print(error.localizedDescription)
            }
            
            picker.dismiss(animated: true) // Fechando a câmera
        }
        
        // Método chamado quando o usuário cancela a captura
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) // Fechando a câmera
        }
    }
}

