//
//  Model.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 24/05/23.
//

import Foundation

struct ModelText: Idea {
    var id: UUID = UUID()
    var ideiaType: IdeaType = .text
    var title: String
    var isFavorite: Bool = false
    var creationDate: Date
    var modifiedDate: Date
    var description: String
    var textComplete: String
}
