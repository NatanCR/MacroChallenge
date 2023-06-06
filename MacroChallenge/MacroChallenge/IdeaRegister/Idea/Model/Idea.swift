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
    var ideiaType: IdeaType { get }
    var title: String { get set }
    var description: String { get set }
    var textComplete: String { get set }
    var creationDate: Date { get }
    var modifiedDate: Date { get set }
    var isFavorite: Bool { get set }
}
