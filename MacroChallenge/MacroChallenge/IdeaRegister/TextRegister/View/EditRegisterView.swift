//
//  EditRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct EditRegisterView: View {
    private let text: LocalizedStringKey = "ideaDay"
    @State var modelText: ModelText
    @Environment(\.dismiss) private var dismiss
    @Environment(\.screenSize) private var screenSize
    // text
    @FocusState var isFocused: Bool
    private let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    @State var showSheet: Bool = false
    @ObservedObject var viewModel: IdeasViewModel
    @State var tagsArray: [Tag] = [] //TODO: fazer com que o usuario possa adicionar novas tags a partir dessa tela 
    
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
                    
                } label: {
                    Image("tag_icon")
                }
            } else {
                Button {
                    self.showSheet = true
                } label: {
                    IdeaTagViewerComponent(idea: modelText)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            TagView(viewModel: viewModel, tagsArrayReceived: $viewModel.tagsLoadedData)
        }
        .onChange(of: modelText.textComplete, perform: { newValue in
            self.saveIdea()
        })
        .navigationBarBackButtonHidden()
        .navigationTitle(Text(text) + Text(modelText.creationDate.toString(dateFormatter: self.dateFormatter)!))
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
    private func saveIdea() {
        let text = self.modelText.textComplete
        if let lastCharacter = text.last, lastCharacter.isWhitespace { return }
        
        self.modelText.modifiedDate = Date()
        TextViewModel.setTextsFromIdea(idea: &self.modelText)
        IdeaSaver.changeSavedValue(type: ModelText.self, idea: self.modelText)
    }
}
