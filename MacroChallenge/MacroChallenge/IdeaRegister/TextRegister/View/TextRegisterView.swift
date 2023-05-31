//
//  TextRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct TextRegisterView: View {
    private let height = UIScreen.main.bounds.size.height //trocar pelo geometry
    @ObservedObject var modelData: ModelData //variável que passa os dados registrados à outra variável que acesso o objeto da estrutura
    private let userDefaultsManager = UserDefaultsManager()
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var title: String = ""
    @State private var idea: String = ""
    @State private var isActive: Bool = false //variável para ativar o alerta
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .frame(height: height * 0.2)
                .padding()
                .focused($isFocused)
            Spacer()
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
                    text = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    //verifica se o texto está vazio
                    if text.isEmpty {
                        self.isActive.toggle()
                    } else {
                        //encontrar a primeira ocorrência de um caractere de nova linha no texto
                        if let range = text.rangeOfCharacter(from: .newlines) {
                            //obtem a posição desse caractere
                            let index = text.distance(from: text.startIndex, to: range.lowerBound)
                            //para obter o String.Index correto correspondente à posição de onde o título termina.
                            let titleIndex = text.index(text.startIndex, offsetBy: index)
                            //para extrair a parte do texto anterior
                            title = String(text[..<titleIndex])
                        } else {
                            title = text
                        }
                        //remover o título do texto original
                        self.idea = text.replacingOccurrences(of: title, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        print("TITULO - \(self.title)")
                        print("TEXTO - \(self.idea)")
                        //registra a data da ideia
                        let currentDate = Date()
                        print("HORA DE REGISTRO - \(formatarData(currentDate))")
                        
                        //coloca os dados no formato da estrutura
                        let currentModel = ModelText(title: title, creationDate: currentDate, modifiedDate: currentDate, text: idea)
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
