//
//  AudioIdeia.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Henrique Assis on 24/05/23.
//

import Foundation

struct AudioIdeia : Idea {
    var id: UUID
    var ideiaType: IdeaType = .audio
    var title: String
    var description: String
    var textComplete: String
    var isFavorite: Bool = false
    var creationDate: Date
    var modifiedDate: Date
    var audioPath: String
    var tag: [Tag]?
    
    init(id: UUID = UUID(), title: String, description: String, textComplete: String, creationDate: Date, modifiedDate: Date, audioPath: String, tag: [Tag]?) {
        self.id = id
        self.title = title
        self.description = description
        self.textComplete = textComplete
        self.creationDate = creationDate
        self.modifiedDate = modifiedDate
        self.audioPath = audioPath
        self.tag = tag
    }
}
