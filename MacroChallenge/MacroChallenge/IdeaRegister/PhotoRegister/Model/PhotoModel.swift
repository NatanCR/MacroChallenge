//
//  PhotoModel.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 30/05/23.
//

import Foundation
import SwiftUI

struct PhotoModel: Idea {
    var id: UUID = UUID()
    var ideiaType: IdeaType = .photo
    var title: String
    var description: String
    var textComplete: String
    var isFavorite: Bool = false
    var creationDate: Date
    var modifiedDate: Date
    var capturedImages: String
    
    init(id: UUID = UUID(), title: String, description: String, textComplete: String, creationDate: Date, modifiedDate: Date, capturedImage: String) {
        self.title = title
        self.description = description
        self.textComplete = textComplete
        self.creationDate = creationDate
        self.modifiedDate = modifiedDate
        self.capturedImages = capturedImage
    }
}

enum PhotoModelError: Error {
    case imageSaveError(Error)
    case invalidImageData
}
