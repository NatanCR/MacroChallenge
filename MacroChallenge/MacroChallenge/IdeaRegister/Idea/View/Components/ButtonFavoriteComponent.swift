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
    //@ObservedObject var ideaViewModel: IdeasViewModel
    
    var body: some View {
        Button{
            idea.isFavorite.toggle()
            IdeaSaver.changeSavedValue(type: type, idea: idea)
        } label: {
            HStack {
                Text(LocalizedStringKey(text))
                idea.isFavorite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
            }
        }
        .onAppear {
            if IdeaSaver.getAllSavedIdeas().contains(where: { $0.id == idea.id }) {
                idea = IdeaSaver.getAllSavedIdeas().first(where: { $0.id == idea.id }) as! T
            }
        }
    }
}

//struct ButtonFavoriteComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonFavoriteComponent()
//    }
//}
