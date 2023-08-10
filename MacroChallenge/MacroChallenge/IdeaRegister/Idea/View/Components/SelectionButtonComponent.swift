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
    @Binding var selectedIdeas: [any Idea]
    
    var body: some View {
        Button{
            isSelected.toggle()
//            IdeaSaver.changeSavedValue(type: type, idea: idea)
            if isSelected {
                selectedIdeas.append(idea)
                
                for selectedIdea in selectedIdeas {
                    print("""
                    -----
                    \(selectedIdea)
                    -----
                    """)
                }
                print("*****")
            } else {
                selectedIdeas.removeAll{ $0.id == idea.id }
                
                for selectedIdea in selectedIdeas {
                    print("""
                    -----
                    \(selectedIdea)
                    -----
                    """)
                }
                print("*****")
            }
        } label: {
            HStack {
                Rectangle()
                    .opacity(0.001)
                VStack{
                    HStack {
                        Spacer()
                        isSelected ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "checkmark.circle")
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
