//
//  ButtonFavoriteComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 20/06/23.
//

import SwiftUI

struct ButtonFavoriteComponent<T: Idea>: View {
    var type: T.Type
    var text: String
    @State var idea: T
    
    init(type: T.Type, idea: T, text: String = String()) {
        self.type = type
        self.text = text
        self._idea = State(initialValue: idea)
    }
    
    //MARK: - BODY
    var body: some View {
        Button{
            self.getIdea()
            idea.isFavorite.toggle()
            IdeaSaver.changeSavedValue(type: type, idea: idea)
        } label: {
            HStack {
                Text(LocalizedStringKey(text))
                idea.isFavorite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
            }
        }
        .onAppear {
            self.getIdea()
        }
    }
    
    //MARK: - FUNCs
    private func getIdea() {
        if let savedIdea = IdeaSaver.getAllSavedIdeas().first(where: { $0.id == idea.id }) as? T {
            idea = savedIdea
        }
    }
}

//struct ButtonFavoriteComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonFavoriteComponent()
//    }
//}
