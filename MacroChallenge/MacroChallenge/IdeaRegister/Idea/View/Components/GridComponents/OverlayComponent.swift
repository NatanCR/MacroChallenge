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

    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var selectedIdeas: [UUID]
    
    var body: some View {
        if isAdding {
            SelectionButtonComponent(type: type.self, idea: idea.self, selectedIdeas: $selectedIdeas, ideasViewModel: ideasViewModel)
        } else {
            ButtonFavoriteComponent(type: type.self, idea: idea.self, text: text, viewModel: ideasViewModel)
        }
    }
}

//struct OverlayComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        OverlayComponent()
//    }
//}
