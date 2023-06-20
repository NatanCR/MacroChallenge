//
//  CustomBackButtonComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 15/06/23.
//

import SwiftUI

struct CustomBackButtonComponent<T: Idea>: View {
    @Environment(\.dismiss) var dismiss
    var type: T.Type
    @Binding var idea: T
    
    var body: some View {
        
        Button {
            if let ideaSaved = IdeaSaver.getAllSavedIdeas().first(where: { $0.id == idea.id }) as? T {
                TextViewModel.setTextsFromIdea(idea: &self.idea)
                self.idea.isFavorite = ideaSaved.isFavorite
                IdeaSaver.changeSavedValue(type: self.type, idea: self.idea)
            }
            
            dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("back")
                    .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                //TODO: colocar frame 
            }
        }
    }
}

//struct CustomBackButtonComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomBackButtonComponent()
//    }
//}
