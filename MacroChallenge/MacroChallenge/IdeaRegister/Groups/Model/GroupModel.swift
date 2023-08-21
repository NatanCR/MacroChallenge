//
//  GroupModel.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 09/08/23.
//

import Foundation

struct GroupModel : Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var creationDate: Date
    var modifiedDate: Date
    var ideasIds: [UUID]
    
    init(title: String, creationDate: Date, modifiedDate: Date, ideasIds: [UUID]) {
        self.title = title
        self.creationDate = creationDate
        self.modifiedDate = modifiedDate
        self.ideasIds = ideasIds
    }
}
