//
//  GridViewComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 17/08/23.
//

import SwiftUI

struct GridViewComponent: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    let audioManager: AudioManager
    @Binding var isAdding: Bool
    @Binding var ideaType: [any Idea]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(self.$ideaType, id: \.id) { $ideas in
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
                            TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding)
                        case .audio:
                            AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding)
                        case .photo:
                            let photoIdea = ideas as! PhotoModel
                            ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding)
                        }
                    }
                }
            }
    }
}

//struct GridViewComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        GridViewComponent()
//    }
//}
