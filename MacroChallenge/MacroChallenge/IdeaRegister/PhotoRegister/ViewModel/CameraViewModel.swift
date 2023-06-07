//
//  CameraViewModel.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import Foundation
import SwiftUI

class CameraViewModel: ObservableObject {
//    @Published var capturedImages: [UIImage] = []
    @Published var capturedImages: UIImage = UIImage()

    func captureImage(image: UIImage) {
//        capturedImages.append(image)
        capturedImages = image
        let photoModel = PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImages: capturedImages)
        IdeaSaver.savePhotoIdea(idea: photoModel)
    }
}
