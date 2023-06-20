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
        
        VStack (alignment: .center){
            
            AudioReprodutionComponent(audioManager: self.audioManager, audioURL: self.audioUrl)
                .frame(maxHeight: screenSize.height * 0.05)
                .padding(.top, 70)
                .padding(.bottom, 30)
            
            Text("note")
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .frame(width: screenSize.width * 0.9, alignment: .topLeading)
            
            TextEditor(text: $idea.textComplete)
                .font(.custom("Sen-Regular", size: 17))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: screenSize.width, maxHeight: screenSize.height * 0.8)
                .focused($isFocused)
                .overlay {
                    PlaceholderComponent(idea: idea)
                }
        }
        .navigationTitle("ideaDay" + "\(idea.creationDate.toString(dateFormatter: self.dateFormatter)!)")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: idea.textComplete) { newValue in
            saveIdea()
        }
            
        .onSwipeBack {
            saveIdea()
            dismiss()
        }
        .navigationBarBackButtonHidden()
        
        .toolbar {

            //menu de favoritar e excluir
            ToolbarItem(placement: .navigationBarTrailing){
                MenuEditComponent(type: AudioIdeia.self, idea: self.$idea)
            }
            
            //botão que dá dismiss no teclado após edição
            ToolbarItem (placement: .navigationBarTrailing){
                if isFocused{
                    Button{
                        isFocused = false
                    } label: {
                        Text("OK")
                    }
                }
            }
            
            //back button personalizado
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtonComponent(type: AudioIdeia.self, idea: $idea)

            }
        }
    }
    
    //MARK: - FUNCs
    private func saveIdea() {
        TextViewModel.setTextsFromIdea(idea: &self.idea)
        IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: self.idea)
    }
}
