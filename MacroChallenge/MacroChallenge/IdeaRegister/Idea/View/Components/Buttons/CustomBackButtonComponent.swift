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
                
                if self.idea.textComplete != ideaSaved.textComplete {
                    self.idea.modifiedDate = Date()
                    IdeaSaver.changeSavedValue(type: self.type, idea: self.idea)
                }
            }
            
            dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("back")
                    .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
            }
        }
    }
}

struct CustomActionBackButtonComponent : View {
    @Environment(\.dismiss) var dismiss
    let buttonText: String
    let action: () -> Void
    let willDismiss: Bool
    let image: String
    
    init(image: String = "chevron.backward", buttonText: String = "back", willDismiss: Bool = true, action: @escaping () -> Void) {
        self.image = image
        self.buttonText = buttonText
        self.willDismiss = willDismiss
        self.action = action
    }
    
    var body: some View {
        
        Button {
            action()
            if willDismiss { dismiss() }
        } label: {
            HStack {
                Image(systemName: image)
                Text(String(localized: String.LocalizationValue(stringLiteral: self.buttonText)))
                    .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
            }
        }
    }
}

//struct CustomBackButtonComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomBackButtonComponent()
//    }
//}
