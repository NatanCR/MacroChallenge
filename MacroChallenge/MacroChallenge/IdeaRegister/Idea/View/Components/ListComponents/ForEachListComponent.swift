//
//  ForEachListComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 28/08/23.
//

import SwiftUI

struct ForEachListComponent: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Binding var ideaType: [any Idea]
    
    var body: some View {
        ForEach(self.$ideaType, id: \.id) { $ideas in
            NavigationLink {
                switch ideas.ideiaType {
                case .text:
                    EditRegisterView(modelText: ideas as! ModelText, viewModel: viewModel)
                case .audio:
                    CheckAudioView(audioIdea: ideas as! AudioIdea, viewModel: viewModel)
                case .photo:
                    PhotoIdeaView(photoModel: ideas as! PhotoModel, viewModel: viewModel)
                }
            } label: {
                if let photoIdea = ideas as? PhotoModel {
                    ListRowComponent(ideasViewModel: self.viewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage())
                }
                else {
                    ListRowComponent(ideasViewModel: self.viewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage())
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

//struct ForEachListComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEachListComponent()
//    }
//}
