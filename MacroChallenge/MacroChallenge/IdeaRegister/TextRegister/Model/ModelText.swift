//
//  Model.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 24/05/23.
//

import Foundation

struct ModelText: Idea {
    var id: UUID
    var ideiaType: IdeaType = .text
    var title: String
    var isFavorite: Bool = false
    var creationDate: Date
    var modifiedDate: Date
    var description: String
    var textComplete: String
    var tag: [Tag]?
    
    init(id: UUID = UUID(), title: String, creationDate: Date, modifiedDate: Date, description: String, textComplete: String, tag: [Tag]?) {
        self.id = id
        self.title = title
        self.creationDate = creationDate
        self.modifiedDate = modifiedDate
        self.description = description
        self.textComplete = textComplete
        self.tag = tag
    }
}
