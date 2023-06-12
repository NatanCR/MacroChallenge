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
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TextEditor(text: $textComplete)
                    .frame(height: geo.size.height * 0.2)
                    .padding()
                    .focused($isFocused)
                Spacer()
            }
        }
        .navigationTitle("Inserir texto")
        .onAppear {
            isFocused = true
        }
        .alert("Escreva uma ideia", isPresented: $isActive, actions: {
            Button(role: .cancel) {
            } label: {
                Text("OK")
            }
        }, message: {
            Text("É necessário escrever uma ideia para salvar.")
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
                        let currentModel = ModelText(title: title, creationDate: Date(), modifiedDate: Date(), description: idea, textComplete: textComplete)
                        //salva o dados registrados
                        IdeaSaver.saveTextIdea(idea: currentModel)
                        dismiss()
                    }
                    
                } label: {
                    Text("OK")
                }
            }
        }
    }
}



//struct TextRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextRegisterView()
//    }
//}
