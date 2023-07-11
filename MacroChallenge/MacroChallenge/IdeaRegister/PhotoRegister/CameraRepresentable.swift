//
//  CameraRepresentable.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Rodrigo Ferreira Pereira on 25/05/23.
//

import AVFoundation
import SwiftUI
import Combine
import Foundation

struct CameraRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    @Binding var tookPicture: Bool
    @ObservedObject var viewModel: CameraViewModel
    @StateObject var ideasViewModel: IdeasViewModel = IdeasViewModel()
    @Environment(\.dismiss) var dismiss
    @State var firstPermission: Bool = {
        if let value = UserDefaults.standard.object(forKey: "FirstPermission") as? Bool {
            return value
        } else {
            return true
        }
    }()
    
    init(tookPicture: Binding<Bool>,viewModel: CameraViewModel) {
        self._tookPicture = tookPicture
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator // Definindo o delegate
        
        let denied = String.LocalizationValue(stringLiteral: "denied")
        let camDeny = String.LocalizationValue(stringLiteral: "camDenyMessage")
        let cancel = String.LocalizationValue(stringLiteral: "cancel")
        let openConfig = String.LocalizationValue(stringLiteral: "openConfig")
        
        viewModel.checkCameraPermission { granted in
            if granted {
                DispatchQueue.main.async {
                    ideasViewModel.isShowingCamera = true
                }
            } else {
                print(firstPermission)
                if firstPermission {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(false, forKey: "FirstPermission")
                        self.dismiss()
                    }
                    
                } else {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        let alert = UIAlertController(title: String(localized: denied), message: String(localized: camDeny), preferredStyle: .alert)
                        
                        //Obtém a cena de janela ativa
                        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            let window = UIWindow(windowScene: windowScene)
                            window.rootViewController = UIViewController()
                            window.windowLevel = UIWindow.Level.alert + 1
                            window.makeKeyAndVisible()
                            window.rootViewController?.present(alert, animated: true, completion: nil)
                            
                            alert.addAction(UIAlertAction(title: String(localized: cancel), style: .default, handler: { _ in
                                window.rootViewController?.dismiss(animated: true, completion: nil)
                                dismiss()
                            }))
                            alert.addAction(UIAlertAction(title: String(localized: openConfig), style: .cancel, handler: { _ in
                                window.rootViewController?.dismiss(animated: true, completion: nil)
                                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                            }))
                        }
                    }
                }
            }
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
            
            parent.tookPicture = true
            picker.dismiss(animated: true) // Fechando a câmera
        }
        
        // Método chamado quando o usuário cancela a captura
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) // Fechando a câmera
        }
    }
}

