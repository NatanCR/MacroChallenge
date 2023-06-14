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
        
        VStack (alignment: .leading){
//            Text("Ideia do dia \(idea.creationDate.toString(dateFormatter: self.dateFormatter)!)")
//                .font(.custom("Sen-Bold", size: 23))
//                .multilineTextAlignment(.leading)
            
            AudioReprodutionComponent(audioManager: self.audioManager, audioURL: self.audioUrl)
                .frame(height: 10)
                .padding(.top, 70)
                .padding(.bottom, 30)
            
            Text("Notas")
                .font(.custom("Sen-Bold", size: 17))
                .multilineTextAlignment(.leading)
                .frame(width: screenSize.width * 0.9, alignment: .topLeading)
            
            TextEditor(text: $idea.textComplete)
                .font(.custom("Sen-Regular", size: 17))
                .multilineTextAlignment(.leading)
                .frame(width: screenSize.width, height: screenSize.height * 0.8, alignment: .topLeading)
                .overlay {
                    Text(self.idea.textComplete.isEmpty ? "Digite sua nota." : "")
                        .font(.custom("Sen-Regular", size: 17))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(8)
                        .foregroundColor(Color("labelColor"))
                        .opacity(0.6)
                        .onTapGesture {
                            self.isFocused = true
                        }
                }
 
            Spacer()
        }
        .navigationTitle("Ideia do dia \(idea.creationDate.toString(dateFormatter: self.dateFormatter)!)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {

            ToolbarItem(placement: .navigationBarTrailing){
                
                Menu{
                    //TODO: aplicar ação de favoritar e trocar o ícone para "heart.fill" quando estiver favoritado
                    Button{
                        print("ok")
                    } label: {
                        HStack{
                            Text("Favorite")
                            Image(systemName: "heart")
                        }
                    }
                    
                    Divider()
                    
                    Button(role: .destructive){
                        IdeaSaver.clearOneIdea(type: AudioIdeia.self, idea: self.idea)
                        ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: self.idea.audioPath)
                        dismiss()
                    } label: {
                        HStack{
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            
            ToolbarItem (placement: .navigationBarTrailing){
                
                //TODO: fazer botão de OK aparecer apenas quando estiver editando
                    Button {
                        TextViewModel.setTextsFromIdea(idea: &self.idea)
                        IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: self.idea)
                        dismiss()
                    } label: {
                        Text("OK")
                    }
            }

            
            //back button personalizado
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    TextViewModel.setTextsFromIdea(idea: &self.idea)
//                    IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: self.idea)
//                    dismiss()
//                } label: {
//                    HStack {
//                        Image(systemName: "chevron.backward")
//                        Text("Voltar")
//                    }
//                }
//            }
        }
    }
}
