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
    @State var isSelected: Bool = false
    @Binding var isAdding: Bool
    
    var body: some View {
        if isAdding{
            SelectionButtonComponent(type: type.self, idea: idea.self)
        } else {
            ButtonFavoriteComponent(type: type.self, text: text, idea: idea.self)
        }
    }
}

//struct OverlayComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        OverlayComponent()
//    }
//}
