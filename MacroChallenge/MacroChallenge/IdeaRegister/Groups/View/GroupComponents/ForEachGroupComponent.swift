//
//  ForEachGroupComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 20/09/23.
//

import SwiftUI

struct ForEachGroupComponent: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var ideaType: [any Idea]
    @Binding var isAdding: Bool
    @Binding var selectedIdeas: Set<UUID>
    @State var group: GroupModel
    
    var body: some View {
        
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
                            if let photoIdea = ideas as? PhotoModel {
                                ListRowComponent(ideasViewModel: self.ideasViewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage())
                            }
                            else {
                                ListRowComponent(ideasViewModel: self.ideasViewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage())
                            }
                        }
                    }
                }
            }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("labelColor"), lineWidth: 1)
                .padding(5)
        )
        .listRowSeparator(.hidden)
    }
}

//struct ForEachGroupComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEachGroupComponent()
//    }
//}
