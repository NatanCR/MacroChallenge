//
//  Idea.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Henrique Assis on 25/05/23.
//

import Foundation

public enum IdeaType : String, CaseIterable, Codable {
    case text = "Text"
    case audio = "Audio"
    case photo = "Photo"
}

protocol Idea : Codable, Hashable, Identifiable {
    var id: UUID { get }
    var name: String { get set }
    var ideiaType: IdeaType { get }
    var creationDate: Date { get }
    var modifiedDate: Date { get set }
}
