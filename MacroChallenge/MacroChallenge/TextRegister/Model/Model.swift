//
//  Model.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 24/05/23.
//

import Foundation

struct Model: Codable, Identifiable {
    var id = UUID()
    var title: String
    var text: String
    var dateCreation: Date
}

class ModelData: ObservableObject {
    //Objeto de acesso ao model
    @Published var model: [Model] = []
}
