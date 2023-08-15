//
//  PhotoIdeaView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import SwiftUI

struct PhotoIdeaView: View {
    @State var photoModel: PhotoModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.screenSize) var screenSize
    @State private var showAlert = false
    
    //título traduzido
    private var text: LocalizedStringKey = "ideaDay"
    
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    var photoURL: URL? = nil
    
    @FocusState var isFocused: Bool
    // tag sheet and array
    @State private var showSheet: Bool = false
    @State var tagsArray: [Tag] = []
    // view model functions and arrays
    @ObservedObject var viewModel: IdeasViewModel
    
    
    init(photoModel: PhotoModel, viewModel: IdeasViewModel) {
        self._photoModel = State(initialValue: photoModel)
        self.photoURL = ContentDirectoryHelper.getDirectoryContent(contentPath: photoModel.capturedImages)
        self.viewModel = viewModel
    }
    
    var body: some View {
        if let uiImage = UIImage(contentsOfFile: photoURL!.path) {
            
            VStack (alignment: .leading){
                
                VStack(alignment: .center){
                    IdeaDateTitleComponent(willBeByCreation: viewModel.isSortedByCreation, idea: photoModel)
                    Image(uiImage: uiImage)
                        .resizable()
                        .cornerRadius(25)
                        .scaledToFill()
                        .rotationEffect(.degrees(90))
                        .frame(maxWidth: screenSize.width * 0.5, alignment: .top)
                        .padding([.top, .bottom], 50)
                    
                    TextEditor(text: $photoModel.textComplete)
                        .font(.custom("Sen-Regular", size: 17))
                        .multilineTextAlignment(.leading)
                        .frame(alignment: .topLeading)
                        .focused($isFocused)
                        .overlay {
                            PlaceholderComponent(idea: photoModel)
                        }
                        .padding(9)
                        .onAppear {
                            if !photoModel.textComplete.isEmpty {
                                DispatchQueue.main.async {
                                    // Atualizar a view para exibir o conteúdo existente da variável description
                                    self.photoModel.textComplete = photoModel.textComplete
                                }
                                print(photoURL!.path)
                            }
                        }
                        .onChange(of: photoModel.textComplete) { newValue in
                            saveIdea(newTags: self.tagsArray)
                        }
                    
                }
                if photoModel.tag!.isEmpty {
                        Button {
                            self.showSheet = true
                        } label: {
                            Image("tag_icon")
                        }.padding()
                    } else {
                        Button {
                            //envio as tags que ja existem na ideia para a sheet viu exibir pro usuário
                            self.tagsArray = photoModel.tag ?? []
                            self.showSheet = true
                        } label: {
                            HorizontalTagScrollComponent(tags: photoModel.tag ?? tagsArray)
                        }.padding()
                    }
            }
            .frame(width: screenSize.width, height: screenSize.height * 0.95, alignment: .top)
            .sheet(isPresented: $showSheet) {
                TagView(viewModel: viewModel, tagsArrayReceived: $tagsArray)
            }
            .onAppear {
                if !photoModel.textComplete.isEmpty {
                    DispatchQueue.main.async {
                        // Atualizar a view para exibir o conteúdo existente da variável description
                        self.photoModel.textComplete = photoModel.textComplete
                    }
                    print(photoURL!.path)
                }
                viewModel.tagsFiltered = viewModel.tagsLoadedData
            }
            .onChange(of: photoModel.textComplete) { newValue in
                self.tagsArray = photoModel.tag ?? []
                saveIdea(newTags: self.tagsArray)
            }
            //recebe e salva as tags adicionadas pela tela da sheet
            .onChange(of: showSheet, perform: { newValue in
                if !showSheet {
                    if self.tagsArray != self.photoModel.tag {
                        saveIdea(newTags: self.tagsArray)
                    } else {
                        return
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isFocused {
                        ButtonFavoriteComponent(type: PhotoModel.self, idea: $photoModel.wrappedValue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isFocused {
                        DeleteIdeaComponent(idea: $photoModel, type: PhotoModel.self)
                    }
                }
                
                ToolbarItem (placement: .navigationBarTrailing){
                    if isFocused{
                        Button{
                            isFocused = false
                        } label: {
                            Text("OK")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButtonComponent(type: PhotoModel.self, idea: $photoModel)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("sucess"),
                    message: Text("delSucess"),
                    dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    //MARK: - FUNCs
    private func saveIdea(newTags: [Tag]) {
        let text = self.photoModel.textComplete
        if let lastCharacter = text.last, lastCharacter.isWhitespace { return }
        
        self.photoModel.modifiedDate = Date()
        //reescrevo os elementos do array com o array que voltou da sheet de tags
        self.photoModel.tag = newTags
        TextViewModel.setTextsFromIdea(idea: &self.photoModel)
        IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: self.photoModel)
    }
}
