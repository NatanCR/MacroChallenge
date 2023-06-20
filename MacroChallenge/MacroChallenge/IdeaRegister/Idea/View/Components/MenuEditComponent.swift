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
    
    var body: some View {
        
        Menu{
            //TODO: aplicar ação de favoritar e trocar o ícone para "heart.fill" quando estiver favoritado
            ButtonFavoriteComponent(type: type, idea: $idea.wrappedValue)
            
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
        
        //TODO: fazer a tradução do alerta
        .confirmationDialog("Do you really want to do this?", isPresented: $isAlertActive) {
            Button("Delete Idea", role: .destructive) {
                //deletar
                IdeaSaver.clearOneIdea(type: self.type, idea: self.idea)
                
                if let audioIdea = idea as? AudioIdeia {
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
