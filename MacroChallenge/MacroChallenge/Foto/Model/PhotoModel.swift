//
//  FotoModel.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 30/05/23.
//

import Foundation
import SwiftUI

struct PhotoModel: Idea {
    var id: UUID = UUID()
    var name: String
    var ideiaType: IdeaType = .photo
    var creationDate: Date
    var modifiedDate: Date
    var capturedImages: [Data]
    
    init(name: String, creationDate: Date, modifiedDate: Date, capturedImages: [UIImage]) {
        self.name = name
        self.creationDate = creationDate
        self.modifiedDate = modifiedDate
        self.capturedImages = []
        
        for image in capturedImages {
            self.capturedImages.append(image.pngData()!)
        }
    }
}
