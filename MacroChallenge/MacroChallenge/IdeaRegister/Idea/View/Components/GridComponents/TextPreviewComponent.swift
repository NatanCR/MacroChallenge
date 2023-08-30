//
//  TextPreviewView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct TextPreviewComponent: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.screenSize) var screenSize
    var text: String
    var title: String
    @Binding var idea: any Idea
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State private var isAlertActive: Bool = false
    @Binding var isAdding: Bool
    @Binding var selectedIdeas: [UUID]
    var group: GroupModel?
    
    init(text: String, title: String, idea: Binding<any Idea>, ideasViewModel: IdeasViewModel, isAdding: Binding<Bool>, selectedIdeas: Binding<[UUID]>, group: GroupModel? = nil) {
        self.text = text
        self.title = title
        self._idea = idea
        self.ideasViewModel = ideasViewModel
        self._isAdding = isAdding
        self._selectedIdeas = selectedIdeas
        self.group = group
    }
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: screenSize.width * 0.26, height: screenSize.width * 0.26)
                    .overlay(alignment: .topTrailing){
                        
                        OverlayComponent(type: ModelText.self, text: "", idea: $idea.wrappedValue as! ModelText, isAdding: $isAdding, selectedIdeas: $selectedIdeas, ideasViewModel: ideasViewModel)
                            .padding(8)
                    }
                
                Text(text)
                    .foregroundColor(Color("labelColor"))
                    .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    .frame(width: screenSize.width * 0.22, height: screenSize.width * 0.15)
                
            }
            .padding(.bottom, 5)
            .contextMenu {
                if idea.grouped {
                    Button(role: .none){
                        if group != nil {
                            IdeaSaver.removeIdeaIdFromGroup(group: self.group!, ideaId: idea.id)
                        }
                        idea.grouped = false
                        IdeaSaver.changeSavedValue(type: ModelText.self, idea: idea as! ModelText)
                        ideasViewModel.resetDisposedData()
                        NotificationCenter.default.post(name: Notification.Name("RemovedIdeaFromGroup"), object: self)
                    } label: {
                        HStack{
                            Text("remove")
                            Image(systemName: "minus.circle")
                        }
                    }
                }
                
                Button(role: .destructive){
                    isAlertActive = true
                } label: {
                    HStack{
                        Text("del")
                        Image(systemName: "trash")
                    }
                }
            }
            
            Text(title)
                .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            
        }
        
        .confirmationDialog("delMsg", isPresented: $isAlertActive) {
            Button("delIdea", role: .destructive) {
                //deletar
                IdeaSaver.clearOneIdea(type: ModelText.self, idea: idea as! ModelText)
                self.ideasViewModel.updateSectionIdeas()
            }
        }
    }
}

//struct TextPreviewComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TextPreviewComponent(text: "", title: "", editDate: Date(), idea: )
//    }
//}
