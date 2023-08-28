//
//  ListViewComponente.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 17/08/23.
//

import SwiftUI

struct ListViewComponent: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    @State var selection = Set<UUID>()
    
    var body: some View {
        List {
            ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
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
            .listRowBackground(Color("backgroundItem"))
        }
    }
}

//struct ListViewComponente_Previews: PreviewProvider {
//    static var previews: some View {
//        ListViewComponente()
//    }
//}
