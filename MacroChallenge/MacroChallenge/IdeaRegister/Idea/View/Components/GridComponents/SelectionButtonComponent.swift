//
//  SelectionButtonComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/07/23.
//

import SwiftUI

struct SelectionButtonComponent<T: Idea>: View {
    var type: T.Type
    @State var idea: T
    @State var isSelected: Bool = false
    
    var body: some View {
        Button{
            isSelected.toggle()
            IdeaSaver.changeSavedValue(type: type, idea: idea)
        } label: {
            HStack {
                isSelected ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "checkmark.circle")
            }
        }
    }
}

//struct SelectionButtonComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionButtonComponent()
//    }
//}
