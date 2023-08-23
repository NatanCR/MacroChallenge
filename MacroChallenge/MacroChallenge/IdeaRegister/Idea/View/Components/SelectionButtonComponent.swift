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
    @Binding var selectedIdeas: [UUID]
    
    var body: some View {
        Button{
            isSelected.toggle()
            if isSelected {
                idea.grouped = true
                saveIdea(idea: idea)
                selectedIdeas.append(idea.id)
            } else {
                idea.grouped = false
                saveIdea(idea: idea)
                selectedIdeas.removeAll{ $0 == idea.id }
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

func saveIdea(idea: any Idea) {
    switch idea {
    case is ModelText:
        IdeaSaver.changeSavedValue(type: ModelText.self, idea: idea as! ModelText)
    case is AudioIdea:
        IdeaSaver.changeSavedValue(type: AudioIdea.self, idea: idea as! AudioIdea)
    case is PhotoModel:
        IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: idea as! PhotoModel)
    default:
        break
    }
}

//struct SelectionButtonComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionButtonComponent()
//    }
//}
