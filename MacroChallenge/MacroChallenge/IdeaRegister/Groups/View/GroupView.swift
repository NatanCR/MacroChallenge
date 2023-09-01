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
    @Binding var isNewIdea: Bool
    private let removedIdeaNotification = NotificationCenter.default.publisher(for: NSNotification.Name("RemovedIdeaFromGroup"))
    
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
                                        TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, group: group, isNewIdea: $isNewIdea)
                                    case .audio:
                                        AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding, selectedIdeas: $selectedIdeas, group: group, isNewIdea: $isNewIdea)
                                    case .photo:
                                        let photoIdea = ideas as! PhotoModel
                                        ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, group: group, isNewIdea: $isNewIdea)
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
        .onChange(of: group, perform: { newValue in
            group.modifiedDate = Date()
            IdeaSaver.changeSavedGroup(newGroup: group)
        })
        .onAppear() {
            if isNewIdea {
                IdeaSaver.saveGroup(group: group)
            }
        }
        .onReceive(removedIdeaNotification, perform: { _ in
            removeIdea()
        })
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if isFocused{
                    Button{
                        isFocused = false
                    } label: {
                        Text("OK")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                //TODO: transformar isAdding em false quando arrastar para voltar
                //back button
                Button{
                    if isAdding{
                        isAdding = false
                    } else {
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("back")
                            .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    }
                }
            }
        }
        .background(Color("backgroundColor"))
    }
    
    func removeIdea() {
        self.ideasViewModel.resetDisposedData()
        let index = self.ideasViewModel.groups.firstIndex(where: {$0.id == group.id}) ?? -1
        if index != -1 {
            group.ideasIds = self.ideasViewModel.groups[index].ideasIds
        }
    }
}


//struct GroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupView()
//    }
//}
