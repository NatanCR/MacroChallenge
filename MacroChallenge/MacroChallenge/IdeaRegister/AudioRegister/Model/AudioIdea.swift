//
//  AudioIdeia.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Henrique Assis on 24/05/23.
//

import Foundation

struct AudioIdeia : Idea {
    var id: UUID
    var name: String
    var ideiaType: IdeaType
    var creationDate: Date
    var modifiedDate: Date
    var audioPath: URL
}
