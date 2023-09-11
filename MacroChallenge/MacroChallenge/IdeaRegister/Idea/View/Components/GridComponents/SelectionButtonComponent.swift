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
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    var body: some View {
        Button{
            isSelected.toggle()
            print(idea.id)
            isSelected ? selectedIdeas.append(idea.id) : selectedIdeas.removeAll{ $0 == idea.id }
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
        .onChange(of: selectedIdeas) { newValue in
            if ideasViewModel.selectedGroup != nil {
                self.ideasViewModel.selectedGroup?.ideasIds = selectedIdeas
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
