//
//  DeleteIdeaComponent.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 04/08/23.
//

import SwiftUI

struct DeleteIdeaComponent<T: Idea>: View {
    @Environment(\.dismiss) var dismiss
    @Binding var idea: T
    let type: T.Type
    
    @State var isAlertActive: Bool = false
    
    var body: some View {
        Button(role: .destructive){
            isAlertActive = true
        } label: {
            Image(systemName: "trash").foregroundColor(Color("deleteColor"))
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
