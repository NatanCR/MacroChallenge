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
    
    //título traduzido
    private var text: LocalizedStringKey = "ideaDay"
    
    //idea
    @State var idea: AudioIdeia
    
    // audio
    private let audioManager: AudioManager
    private let audioUrl: URL
    
    // date
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    // text
    @FocusState var isFocused: Bool
    
    // tag
    @State private var showSheet: Bool = false
    @State var tagsArray: [Tag] = []
    
    // view model functions
    @ObservedObject var viewModel: IdeasViewModel
    
    
    init(audioIdea idea: AudioIdeia, viewModel: IdeasViewModel) {
        self.audioManager = AudioManager()
        self._idea = State(initialValue: idea)
        self.viewModel = viewModel
        self.audioUrl = ContentDirectoryHelper.getDirectoryContent(contentPath: idea.audioPath)
        self.audioManager.assignAudio(self.audioUrl)
        self.isFocused = false
    }
    
    //MARK: - BODY
    var body: some View {
        
        VStack (alignment: .center) {
            IdeaDateTitleComponent(willBeByCreation: viewModel.isSortedByCreation, idea: idea)
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
                .frame(maxWidth: screenSize.width * 0.95, maxHeight: screenSize.height * 0.8)
                .focused($isFocused)
                .overlay {
                    PlaceholderComponent(idea: idea)
                }
            
            
            VStack (alignment: .leading) {
                if idea.tag!.isEmpty {
                    Button {
                        self.showSheet = true
                    } label: {
                        Image("tag_icon")
                    }
                } else {
                    Button {
                        self.tagsArray = idea.tag ?? []
                        self.showSheet = true
                    } label: {
                        IdeaTagViewerComponent(idea: idea)
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet, content: {
            TagView(viewModel: viewModel, tagsArrayReceived: $tagsArray)
        })
        
        .onChange(of: idea.textComplete) { newValue in
            self.tagsArray = idea.tag ?? []
            saveIdea(newTags: self.tagsArray)
        }
        .onChange(of: showSheet, perform: { newValue in
            if self.tagsArray != self.idea.tag {
                saveIdea(newTags: self.tagsArray)
            } else {
                return
            }
            
        })
        .onAppear {
            viewModel.tagsFiltered = viewModel.tagsLoadedData
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
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
                        saveIdea(newTags: self.tagsArray)
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
    private func saveIdea(newTags: [Tag]) {
        let text = self.idea.textComplete
        if let lastCharacter = text.last, lastCharacter.isWhitespace { return }
        
        self.idea.modifiedDate = Date()
        
        self.idea.tag = newTags
        
        TextViewModel.setTextsFromIdea(idea: &self.idea)
        IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: self.idea)
    }
}
