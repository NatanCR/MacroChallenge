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
    var creationDate: Date
    var modifiedDate: Date
    var text: String
    var textComplete: String
}

//class ModelData: ObservableObject {
//    //Objeto de acesso ao model
//    @Published var model: [ModelText] = []
//}
