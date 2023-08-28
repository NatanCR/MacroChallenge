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
                                        TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas)
                                    case .audio:
                                        AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, selectedIdeas: $selectedIdeas, isAdding: $isAdding)
                                    case .photo:
                                        let photoIdea = ideas as! PhotoModel
                                        ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas)
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
        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                //                MenuEditComponent(type: , idea: )
//                Button{
//                    
//                } label: {
//                    Image(systemName: "ellipsis.circle")
//                }
//                
//            }
            
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
                        IdeaSaver.saveGroup(group: group)
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .background(Color("backgroundColor"))
    }
}

//struct GroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupView()
//    }
//}
