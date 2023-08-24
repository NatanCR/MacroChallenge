//
//  TextRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct TextRegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var textComplete: String = ""
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var saveAlertIsActive: Bool = false //variável para ativar o alerta
    @State private var cancelAlertIsActive: Bool = false
    @FocusState private var isFocused: Bool
    @State private var showTagSheet: Bool = false
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State var currentModel: ModelText?
    @State var showModal: Bool = false
    @State var tagsArray: [Tag] = []
    @State var createDate: Date = Date()
    @State var ideaID: UUID = UUID()
    
    //MARK: - BODY
    var body: some View {
        VStack (alignment: .leading){
            TextEditor(text: $textComplete)
                .padding()
                .focused($isFocused)
            
            if tagsArray.isEmpty {
                //chama a sheet
                Button {
                    showModal = true
                } label: {
                    Image("tag_icon")
                }.padding()
            } else {
                Button {
                    self.showModal = true
                } label: {
                    //define a formatação das tags
                    IdeaTagViewerComponent<ModelText>(idea: ModelText(title: title, creationDate: Date(), modifiedDate: Date(), description: description, textComplete: textComplete, tag: tagsArray))
                }.padding()

            }
        }
        .onChange(of: textComplete, perform: { newValue in
            self.saveIdea()
        })
        .sheet(isPresented: $showModal) {
            TagView(viewModel: ideasViewModel, tagsArrayReceived: $tagsArray)
        }
        .navigationTitle("insertTxt")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            isFocused = true
        }
        .alert("writeIdea", isPresented: $saveAlertIsActive, actions: {
            Button(role: .cancel) {
            } label: {
                Text("OK")
            }
        }, message: {
            Text("msgIdea")
        })
        .alert("cancelIdea", isPresented: $cancelAlertIsActive, actions: {
            Button(role: .destructive) {
                self.cancelRegister()
                dismiss()
            } label: {
                Text("yes")
            }
            
            Button(role: .cancel) {
                self.cancelAlertIsActive = false
            } label: {
                Text("no")
            }


        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.saveIdea(savedByButton: true)
                    if !self.textComplete.isEmpty {dismiss()}
                } label: {
                    Text("save")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                CustomActionBackButtonComponent(buttonText: "cancel", willDismiss: false, action: {
                    if self.textComplete.isEmpty { self.cancelRegister(); dismiss() }
                    else {
                        self.cancelAlertIsActive = true
                    }
                })
            }
        }.font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
    }
    
    //MARK: - FUNCs
    private func saveIdea(savedByButton: Bool = false) {
        if let lastCharacter = self.textComplete.last, lastCharacter.isWhitespace { return }

        //tira espaços em brancos do texto
        self.textComplete = textComplete.trimmingCharacters(in: .whitespacesAndNewlines)
        //verifica se o texto está vazio
        if self.textComplete.isEmpty {
            self.cancelRegister()
            if savedByButton { self.saveAlertIsActive.toggle() }
        } else {
            TextViewModel.setTitleDescriptionAndCompleteText(title: &title, description: &description, complete: &textComplete)
            var createdIdea = false
            
            //coloca os dados no formato da estrutura
            if self.currentModel == nil {
                self.createDate = Date()
                createdIdea = true
            } else {
                // to prevent re-init from alert
                if self.currentModel?.id != self.ideaID {
                    self.ideaID = self.currentModel?.id ?? UUID()
                    self.createDate = self.currentModel?.creationDate ?? Date()
                }
            }
            
            self.currentModel = ModelText(id: self.ideaID, title: title, creationDate: self.createDate, modifiedDate: Date(), description: description, textComplete: textComplete, tag: tagsArray)
            
            //salva o dados registrados
            guard let idea = self.currentModel else { return }
            
            if createdIdea {
                IdeaSaver.saveTextIdea(idea: idea)
            } else {
                IdeaSaver.changeSavedValue(type: ModelText.self, idea: idea)
            }
        }
    }
    
    private func cancelRegister() {
        if let idea = self.currentModel {
            IdeaSaver.clearOneIdea(type: ModelText.self, idea: idea)
            self.currentModel = nil
        }
    }
}



//struct TextRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextRegisterView()
//    }
//}
