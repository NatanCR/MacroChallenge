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
    var creationDate: Date
    var modifiedDate: Date
    var audioPath: URL
    
    init(id: UUID = UUID(), title: String, creationDate: Date, modifiedDate: Date, audioPath: URL) {
        self.id = id
        self.title = title
        self.creationDate = creationDate
        self.modifiedDate = modifiedDate
        self.audioPath = audioPath
    }
}
