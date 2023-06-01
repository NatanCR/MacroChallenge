//
//  TextRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct TextRegisterView: View {
    @ObservedObject var modelData: ModelData //variável que passa os dados registrados à outra variável que acesso o objeto da estrutura
    private let userDefaultsManager = UserDefaultsManager()
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
                        title = TextViewModel.separateTitleFromText(textComplete: textComplete, title: title)!
                        
                        //remover o título do texto original
                        self.idea = textComplete.replacingOccurrences(of: title, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        idea = idea.removeEmptyLines()
                        title = title.removeEmptyLines()
                        textComplete = textComplete.removeEmptyLines()
                        
                        //registra a data da ideia
                        let currentDate = Date()
                        //coloca os dados no formato da estrutura
                        let currentModel = ModelText(title: title, creationDate: currentDate, modifiedDate: currentDate, text: idea, textComplete: textComplete)
                        //adiciona os dados no array do objeto
                        self.modelData.model.append(currentModel)
                        //salva o dados registrados
                        userDefaultsManager.encoderModel(model: modelData.model)
                        dismiss()
                    }
                    
                } label: {
                    Text("OK")
                }
            }
        }
    }

    
    //formata a data em string com o horario local do device
    func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale.current
        return formatter.string(from: data)
    }
}



//struct TextRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextRegisterView()
//    }
//}
