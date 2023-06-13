//
//  CameraViewModel.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import Foundation
import SwiftUI

class CameraViewModel: ObservableObject {
    
    func captureImage(image: UIImage) throws {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let lastComponent = fileURL.lastPathComponent
        
        if let imageData = image.pngData() {
            do {
                try imageData.write(to: fileURL)
            } catch {
                throw PhotoModelError.imageSaveError(error)
            }
        } else {
            throw PhotoModelError.invalidImageData
        }
        
        do {
            let photoModel = try PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImage: lastComponent)
            IdeaSaver.savePhotoIdea(idea: photoModel)
        } catch PhotoModelError.imageSaveError(let error) {
            print("Erro ao salvar a imagem: \(error)")
        } catch PhotoModelError.invalidImageData {
            print("Dados de imagem inválidos")
        } catch {
            print("Erro desconhecido: \(error)")
        }
    }
}
