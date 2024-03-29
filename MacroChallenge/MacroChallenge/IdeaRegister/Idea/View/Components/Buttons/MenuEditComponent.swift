//
//  MenuEditComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 15/06/23.
//

import SwiftUI

struct MenuEditComponent<T: Idea>: View {
    @Environment(\.dismiss) var dismiss
    var type: T.Type
    @Binding var idea: T
    @State private var isAlertActive: Bool = false
    @ObservedObject var viewModel: IdeasViewModel
    
    var body: some View {
        
        Menu{
            ButtonFavoriteComponent(type: type, idea: $idea.wrappedValue, viewModel: viewModel)
            
            Divider()
            
            Button(role: .destructive){
                isAlertActive = true
            } label: {
                HStack{
                    Text("del")
                    Image(systemName: "trash")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        
        .confirmationDialog("delMsg", isPresented: $isAlertActive) {
            Button("delIdea", role: .destructive) {
                //deletar
                IdeaSaver.clearOneIdea(type: self.type, idea: self.idea)
                
                if let audioIdea = idea as? AudioIdea {
                    ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: audioIdea.audioPath)
                }
                else if let photoIdea = idea as? PhotoModel {
                    ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: photoIdea.capturedImages)
                }
                dismiss()

            }
        }
    }
}

//struct MenuEditComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuEditComponent(type: AudioIdeia.self, idea: <#T##_#>)
//    }
//}
