//
//  OverlayComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/07/23.
//

import SwiftUI

struct OverlayComponent<T: Idea>: View {
    var type: T.Type
    var text: String
    @State var idea: T
    @Binding var isAdding: Bool
    @Binding var selectedIdeas: [UUID]
    @Binding var isNewIdea: Bool
    
    var body: some View {
        if isAdding {
            if isNewIdea {
                ButtonFavoriteComponent(type: type.self, idea: idea.self, text: text)
            } else {
                SelectionButtonComponent(type: type.self, idea: idea.self, selectedIdeas: $selectedIdeas)
            }
        } else {
            ButtonFavoriteComponent(type: type.self, idea: idea.self, text: text)
        }
    }
}

//struct OverlayComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        OverlayComponent()
//    }
//}
