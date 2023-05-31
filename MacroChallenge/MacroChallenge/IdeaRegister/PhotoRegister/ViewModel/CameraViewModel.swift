//
//  CameraViewModel.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import Foundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var capturedImages: [UIImage] = []

    func captureImage(image: UIImage) {
        capturedImages.append(image)
        let photoModel = PhotoModel(title: "", creationDate: Date(), modifiedDate: Date(), capturedImages: capturedImages)
        IdeaSaver.savePhotoIdea(idea: photoModel)
    }
}
