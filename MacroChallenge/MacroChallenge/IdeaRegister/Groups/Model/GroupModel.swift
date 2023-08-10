//
//  GroupModel.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 09/08/23.
//

import Foundation

struct GroupModel {
    var id: UUID = UUID()
    var title: String
    var creationDate: Date
    var modifiedDate: Date
    var ideas: [any Idea]
    
    init(title: String, creationDate: Date, modifiedDate: Date, ideas: [any Idea]) {
        self.title = title
        self.creationDate = creationDate
        self.modifiedDate = modifiedDate
        self.ideas = ideas
    }
}
