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
    @State var selectedIdeas: [UUID] = []
    @State var group: GroupModel
    var isNewGroup: Bool
    private let removedIdeaNotification = NotificationCenter.default.publisher(for: NSNotification.Name("RemovedIdeaFromGroup"))
    @State var isIdeaNotGrouped = IdeaSaver.getIdeaNotGrouped()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            TextField("Folder Name", text: $group.title)
                .font(.custom("Sen-Bold", size: 30))
                .padding()
                .focused($isFocused)
            ScrollView{
                //TODO: apresentar ideias da pasta
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(group.ideasIds, id: \.self) { ideaID in
                        ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                            if ideaID == ideas.id {
                                NavigationLink {
                                    switch ideas.ideiaType {
                                    case .text:
                                        EditRegisterView(modelText: ideas as! ModelText, viewModel: ideasViewModel)
                                    case .audio:
                                        CheckAudioView(audioIdea: ideas as! AudioIdea, viewModel: ideasViewModel)
                                    case .photo:
                                        PhotoIdeaView(photoModel: ideas as! PhotoModel, viewModel: ideasViewModel)
                                    }
                                } label: {
                                    switch ideas.ideiaType {
                                    case .text:
                                        TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, group: group)
                                    case .audio:
                                        AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding, selectedIdeas: $selectedIdeas, group: group)
                                    case .photo:
                                        let photoIdea = ideas as! PhotoModel
                                        ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, group: group)
                                    }
                                }
                            }
                        }
                    }
                }
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
        let index = self.ideasViewModel.groups.firstIndex(where: {$0.id == group.id}) ?? -1
        if index != -1 {
            group.ideasIds = self.ideasViewModel.groups[index].ideasIds
            print(self.ideasViewModel.groups[index].ideasIds)
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
