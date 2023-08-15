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
    // idea
    @State var modelText: ModelText
    // text
    @FocusState var isFocused: Bool
    // tag
    @State private var showSheet: Bool = false
    @State var tagsArray: [Tag] = []
    // view model functions and arrays
    @ObservedObject var viewModel: IdeasViewModel
    
    init(modelText: ModelText, viewModel: IdeasViewModel) {
        self._modelText = State(initialValue: modelText)
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        VStack(alignment: .center) {
            IdeaDateTitleComponent(willBeByCreation: viewModel.isSortedByCreation, idea: modelText)
            VStack(alignment: .leading) {
                
                TextEditor(text: $modelText.textComplete)
                    .font(.custom("Sen-Regular", size: 17))
                    .multilineTextAlignment(.leading)
                    .frame(width: screenSize.width * 0.95 ,height: screenSize.height * 0.7)
                    .focused($isFocused)
                    .overlay{
                        PlaceholderComponent(idea: modelText)
                    }
                Spacer()
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
                        HorizontalTagScrollComponent(tags: modelText.tag ?? tagsArray)
                    }
                }
            }
            .padding()
        }
        //frame para usar o tamanho inteiro da tela
        .frame(width: screenSize.width, height: screenSize.height * 0.95, alignment: .top)
        .sheet(isPresented: $showSheet) {
            TagView(viewModel: viewModel, tagsArrayReceived: $tagsArray)
        }
        .onChange(of: modelText.textComplete, perform: { newValue in
            //passando as tags que ja existem antes de salvar a mudança de texto
            self.tagsArray = modelText.tag ?? []
            self.saveIdea(newTags: self.tagsArray)
        })
        //recebe e salva as tags adicionadas pela tela da sheet
        .onChange(of: showSheet, perform: { newValue in
            if !showSheet {
                if self.tagsArray != self.modelText.tag {
                    saveIdea(newTags: self.tagsArray)
                } else {
                    return
                }
            }
        })
        
        .onAppear {
            self.showSheet = false
            viewModel.tagsFiltered = viewModel.tagsLoadedData
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isFocused {
                    ButtonFavoriteComponent(type: ModelText.self, idea: $modelText.wrappedValue)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isFocused {
                    DeleteIdeaComponent(idea: $modelText, type: ModelText.self)
                }
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
