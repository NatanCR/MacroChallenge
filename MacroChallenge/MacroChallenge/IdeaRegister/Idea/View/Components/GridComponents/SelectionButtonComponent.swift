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
    @Binding var selectedIdeas: Set<UUID>
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    var body: some View {
        Button{
            isSelected.toggle()
            if isSelected {
                selectedIdeas.insert(idea.id)
            } else {
                selectedIdeas.remove(idea.id)
            }
        } label: {
            HStack {
                Rectangle()
                    .opacity(0.001)
                VStack{
                    HStack {
                        Spacer()
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
                    }
                    Spacer()
                    Rectangle()
                        .opacity(0.001)
                }
            }
        }
    }
}

//struct SelectionButtonComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionButtonComponent()
//    }
//}
