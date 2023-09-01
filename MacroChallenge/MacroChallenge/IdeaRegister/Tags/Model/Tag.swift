//
//  Tag.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 04/07/23.
//

import Foundation

struct Tag: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var color: String //não é possível decodificar um Color
    var size: CGFloat = 0
    var isTagSelected: Bool = false 
}


