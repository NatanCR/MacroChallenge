//
//  CheckAudioView.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 01/06/23.
//

import SwiftUI
import AVFoundation

struct CheckAudioView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.screenSize) private var screenSize
    
    //idea
    @State var idea: AudioIdeia
    
    // audio
    private let audioManager: AudioManager
    private let audioUrl: URL
    
    // date
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    // text
    @FocusState var isFocused: Bool
    
    init(audioIdea idea: AudioIdeia) {
        self.audioManager = AudioManager()
        self._idea = State(initialValue: idea)
        self.audioUrl = ContentDirectoryHelper.getDirectoryContent(contentPath: idea.audioPath)
        self.audioManager.assignAudio(self.audioUrl)
        self.isFocused = false
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Text("Ideia do dia \(idea.creationDate.toString(dateFormatter: self.dateFormatter)!)")
                .font(.system(size: 23))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            AudioReprodutionComponent(audioManager: self.audioManager, audioURL: self.audioUrl)
                .frame(height: 10)
                .padding(.top, 30)
                .padding(.bottom, 30)
            
            Text("Notas")
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .frame(width: screenSize.width * 0.9, alignment: .topLeading)
            
            TextEditor(text: $idea.textComplete)
                .multilineTextAlignment(.leading)
                .frame(width: screenSize.width * 0.8, alignment: .topLeading)
                .overlay {
                    Text(self.idea.textComplete.isEmpty ? "Digite sua nota." : "")
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            self.isFocused = true
                        }
                }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    IdeaSaver.clearOneIdea(type: AudioIdeia.self, idea: self.idea)
                    ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: self.idea.audioPath)
                    dismiss()
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }

            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    TextViewModel.setTextsFromIdea(idea: &self.idea)
                    IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: self.idea)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Voltar")
                    }
                }
            }
        }
    }
}
