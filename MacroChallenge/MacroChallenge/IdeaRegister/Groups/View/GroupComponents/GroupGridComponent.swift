//
//  GroupGridComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 20/09/23.
//

import SwiftUI

struct GroupGridComponent: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.screenSize) var screenSize
    
    let audioManager: AudioManager = AudioManager()
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    @FocusState var isFocused: Bool
    @State var group: GroupModel
    @Binding var selectedIdeas: Set<UUID>
    private let removedIdeaNotification = NotificationCenter.default.publisher(for: NSNotification.Name("RemovedIdeaFromGroup"))
    @State var isIdeaNotGrouped = IdeaSaver.getIdeaNotGrouped()
    @Binding var ideaType: [any Idea]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(group.ideasIds, id: \.self) { ideaID in
                ForEach(self.$ideaType, id: \.id) { $ideas in
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

//struct GroupGridComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupGridComponent()
//    }
//}
