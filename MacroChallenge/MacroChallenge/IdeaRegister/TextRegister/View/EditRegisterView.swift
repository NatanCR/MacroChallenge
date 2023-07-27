//
//  EditRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct EditRegisterView: View {
    // config
    @Environment(\.dismiss) private var dismiss
    @Environment(\.screenSize) private var screenSize
    // title
    private let text: LocalizedStringKey = "ideaDay"
    // idea
    @State var modelText: ModelText
    // text
    @FocusState var isFocused: Bool
    // tag
    @State private var showSheet: Bool = false
    @State var tagsArray: [Tag] = []
    // view model functions
    @ObservedObject var viewModel: IdeasViewModel
    
    init(modelText: ModelText, viewModel: IdeasViewModel) {
        self._modelText = State(initialValue: modelText)
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $modelText.textComplete)
                .frame(width: screenSize.width * 0.95 ,height: screenSize.height * 0.8)
                .focused($isFocused)
                .overlay{
                    PlaceholderComponent(idea: modelText)
                }
            if modelText.tag!.isEmpty {
                Button {
                    self.showSheet = true
                } label: {
                    Image("tag_icon")
                }
            } else {
                Button {
                    //envio as tags que ja existem na ideia para a sheet viu exibir pro usuário
                    self.tagsArray = modelText.tag ?? []
                    self.showSheet = true
                } label: {
                    IdeaTagViewerComponent(idea: modelText)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            TagView(viewModel: viewModel, tagsArrayReceived: $tagsArray)
        }
        .onChange(of: modelText.textComplete, perform: { newValue in
            self.saveIdea(newTags: self.tagsArray)
        })
        .onChange(of: showSheet, perform: { newValue in
            if !showSheet {
                print("ARRAY FECHANDO SHEET")
                dump(self.tagsArray)
                if self.tagsArray != self.modelText.tag {
                    saveIdea(newTags: self.tagsArray)
                } else {
                    return
                }
            }
            
            
        })
        .navigationBarBackButtonHidden()
        .navigationTitle(Text(text) + Text(modelText.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                MenuEditComponent(type: ModelText.self, idea: $modelText)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if isFocused{
                    Button{
                        isFocused = false
                    } label: {
                        Text("OK")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtonComponent(type: ModelText.self, idea: $modelText)
            }
        }
    }
    
    
    //MARK: - FUNCs
    private func saveIdea(newTags: [Tag]) {
        let text = self.modelText.textComplete
        if let lastCharacter = text.last, lastCharacter.isWhitespace { return }
        
        self.modelText.modifiedDate = Date()
        //reescrevo os elementos do array com o array que voltou da sheet de tags
        self.modelText.tag = newTags
        
        TextViewModel.setTextsFromIdea(idea: &self.modelText)
        IdeaSaver.changeSavedValue(type: ModelText.self, idea: self.modelText)
    }
    
//    /**Função que filtra tags repetidas antes de adicionar no array da ideia**/
//    func verifyAndUpdateTags(newTags: [Tag]) {
//
//        if let existingTags = modelText.tag {
//            // Verifica se cada tag em newTags já existe em existingTags
//            let duplicateTags = newTags.filter { existingTags.contains($0) }
//
//            // Adiciona apenas as tags não duplicadas em modelText.tag
//            for tag in newTags where !duplicateTags.contains(tag) {
//                modelText.tag?.append(tag)
//            }
//
//        } else {
//            // Se modelText.tag é nulo, simplesmente adiciona todas as tags de newTags
//            modelText.tag = newTags
//            print("can't add new tags in idea")
//        }
//    }
}
