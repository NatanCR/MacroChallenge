//
//  GroupView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 18/08/23.
//

import SwiftUI

struct GroupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.screenSize) var screenSize
    let audioManager: AudioManager = AudioManager()
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    @FocusState var isFocused: Bool
    @State var group: GroupModel
    var isNewGroup: Bool
    @Binding var selectedIdeas: Set<UUID>
    private let removedIdeaNotification = NotificationCenter.default.publisher(for: NSNotification.Name("RemovedIdeaFromGroup"))
    @State var isIdeaNotGrouped = IdeaSaver.getIdeaNotGrouped()
    @Binding var ideaType: [any Idea]
    var grid: Bool
        
    var body: some View {
        VStack{
            TextField("Folder Name", text: $group.title)
                .font(.custom("Sen-Bold", size: 30))
                .padding()
                .focused($isFocused)
                if grid{
                    ScrollView{
                        GroupGridComponent(ideasViewModel: ideasViewModel, isAdding: $isAdding, group: group, selectedIdeas: $selectedIdeas, ideaType: $ideaType)
                    }
                } else {
                    GroupListComponent(ideasViewModel: ideasViewModel, isAdding: $isAdding, group: group, selectedIdeas: $selectedIdeas, ideaType: $ideaType)
                }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: group.title, perform: { newValue in
            group.modifiedDate = Date()
            IdeaSaver.changeSavedGroup(newGroup: group)
        })
        .onChange(of: group.ideasIds, perform: { newValue in
            group.modifiedDate = Date()
            IdeaSaver.changeSavedGroup(newGroup: group)
        })
        .onAppear() {
            isIdeaNotGrouped = IdeaSaver.getIdeaNotGrouped()
            
            if isNewGroup {
                self.ideasViewModel.selectedGroup = nil
                IdeaSaver.saveGroup(group: group)
            }

            self.ideasViewModel.selectedGroup = self.group
            self.ideasViewModel.resetDisposedData()
        }
        .onChange(of: self.ideasViewModel.disposedData.count) { newValue in
            isIdeaNotGrouped = IdeaSaver.getIdeaNotGrouped()
        }
        .onReceive(removedIdeaNotification, perform: { _ in
            removeIdea()
        })
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                //TODO: transformar isAdding em false quando arrastar para voltar
                //back button
                Button{
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("back")
                            .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if isFocused{
                    Button{
                        isFocused = false
                    } label: {
                        Text("OK")
                    }
                } else {
                    //add button
                    Button {
                        isAdding = true
                        dismiss()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .disabled(isIdeaNotGrouped)
                }
            }
        }
        .background(Color("backgroundColor"))
    }
    
    func removeIdea() {
        let index = self.ideasViewModel.groupsDisposedData.firstIndex(where: {$0.id == group.id}) ?? -1
        if index != -1 {
            group.ideasIds = self.ideasViewModel.groupsDisposedData[index].ideasIds
        } else {
            group.ideasIds = []
            dismiss()
        }
        isIdeaNotGrouped = IdeaSaver.getIdeaNotGrouped()
        self.ideasViewModel.selectedGroup = group
        self.ideasViewModel.resetDisposedData()
    }
}


//struct GroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupView()
//    }
//}
