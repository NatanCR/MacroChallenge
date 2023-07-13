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
    @State private var idea: String = ""
    @State private var isActive: Bool = false //variável para ativar o alerta
    @FocusState private var isFocused: Bool
    @State private var showTagSheet: Bool = false
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State var showModal: Bool = false
    @State var tagsArray: [Tag] = []
    
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
                    IdeaTagViewerComponent(idea: ModelText(title: title, creationDate: Date(), modifiedDate: Date(), description: textComplete, textComplete: textComplete, tag: tagsArray))
                }.padding()

            }
        }
        .sheet(isPresented: $showModal) {
            TagView(viewModel: ideasViewModel, tagsArrayReceived: $tagsArray)
        }
        .navigationTitle("insertTxt")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isFocused = true
        }
        .alert("writeIdea", isPresented: $isActive, actions: {
            Button(role: .cancel) {
            } label: {
                Text("OK")
            }
        }, message: {
            Text("msgIdea")
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //tira espaços em brancos do texto
                    textComplete = textComplete.trimmingCharacters(in: .whitespacesAndNewlines)
                    //verifica se o texto está vazio
                    if textComplete.isEmpty {
                        self.isActive.toggle()
                    } else {
                        TextViewModel.setTitleDescriptionAndCompleteText(title: &title, description: &idea, complete: &textComplete)
                        
                        //coloca os dados no formato da estrutura
                        let currentModel = ModelText(title: title, creationDate: Date(), modifiedDate: Date(), description: idea, textComplete: textComplete, tag: tagsArray)
                        
                        dump(tagsArray)
                        
                        //salva o dados registrados
                        IdeaSaver.saveTextIdea(idea: currentModel)
                        dismiss()
                    }
                } label: {
                    Text("save")
                }
            }
        }.font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
    }
}



//struct TextRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextRegisterView()
//    }
//}
